//
//  Container.swift
//  Web Grid
//
//  Created by Umur Gedik on 7.12.2021.
//

import Foundation
import CoreData

@objc(Container)
class Container: NSManagedObject, Identifiable {
    public var device: Device {
        get { Device(rawValue: sdevice)! }
        set { sdevice = newValue.rawValue }
    }
    
    public var orientation: Orientation {
        get { Orientation(rawValue: sorientation)! }
        set { sorientation = newValue.rawValue }
    }
    
    @NSManaged private var sdevice: String
    @NSManaged private var sorientation: String
}

extension Container {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Container> {
        NSFetchRequest<Container>(entityName: "Container")
    }
}
