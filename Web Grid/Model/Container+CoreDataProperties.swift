//
//  Container+CoreDataProperties.swift
//  Web Grid
//
//  Created by Umur Gedik on 12.12.2021.
//
//

import Foundation
import CoreData


extension Container {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Container> {
        return NSFetchRequest<Container>(entityName: "Container")
    }

    @NSManaged public var sdevice: String
    @NSManaged public var sorientation: String
    @NSManaged public var page: Page

}

extension Container : Identifiable {

}
