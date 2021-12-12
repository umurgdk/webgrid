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
}
