//
//  Container+CoreDataClass.swift
//  Web Grid
//
//  Created by Umur Gedik on 12.12.2021.
//
//

import Foundation
import CoreData

@objc(Container)
public class Container: NSManagedObject {
    var device: Device {
        get { Device(rawValue: sdevice) ?? .iPhone13Mini }
        set { sdevice = newValue.rawValue }
    }
    
    var orientation: Orientation {
        get { Orientation(rawValue: sorientation) ?? .portrait }
        set { sorientation = newValue.rawValue }
    }
    
    var appearance: Appearance? {
        get { appearanceName.flatMap(Appearance.init(rawValue:)) }
        set { appearanceName = newValue?.rawValue }
    }
    
    var canMoveLeft: Bool {
        order > 0
    }
    
    var canMoveRight: Bool {
        order < page.containers.count - 1
    }
    
    func moveLeft() {
        guard let context = managedObjectContext, canMoveLeft else { return }
        
        let previousContainer = page.containers.filter { $0.order < self.order }.max(by: { $0.order < $1.order })
        guard let previousContainer = previousContainer else { return }
        
        let order = self.order
        self.order = previousContainer.order
        previousContainer.order = order
        
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
    
    func moveRight() {
        guard let context = managedObjectContext, canMoveRight else { return }
        
        let nextContainer = page.containers.filter { $0.order > self.order }.min(by: { $0.order < $1.order })
        guard let nextContainer = nextContainer else { return }
        
        let order = self.order
        self.order = nextContainer.order
        nextContainer.order = order
        
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}
