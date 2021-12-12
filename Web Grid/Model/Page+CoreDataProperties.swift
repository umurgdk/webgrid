//
//  Page+CoreDataProperties.swift
//  Web Grid
//
//  Created by Umur Gedik on 12.12.2021.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var order: Int32
    @NSManaged public var title: String
    @NSManaged public var url: URL
    @NSManaged public var containers: [Container]
    @NSManaged public var site: Site

}

// MARK: Generated accessors for containers
extension Page {

    @objc(insertObject:inContainersAtIndex:)
    @NSManaged public func insertIntoContainers(_ value: Container, at idx: Int)

    @objc(removeObjectFromContainersAtIndex:)
    @NSManaged public func removeFromContainers(at idx: Int)

    @objc(insertContainers:atIndexes:)
    @NSManaged public func insertIntoContainers(_ values: [Container], at indexes: NSIndexSet)

    @objc(removeContainersAtIndexes:)
    @NSManaged public func removeFromContainers(at indexes: NSIndexSet)

    @objc(replaceObjectInContainersAtIndex:withObject:)
    @NSManaged public func replaceContainers(at idx: Int, with value: Container)

    @objc(replaceContainersAtIndexes:withContainers:)
    @NSManaged public func replaceContainers(at indexes: NSIndexSet, with values: [Container])

    @objc(addContainersObject:)
    @NSManaged public func addToContainers(_ value: Container)

    @objc(removeContainersObject:)
    @NSManaged public func removeFromContainers(_ value: Container)

    @objc(addContainers:)
    @NSManaged public func addToContainers(_ values: NSOrderedSet)

    @objc(removeContainers:)
    @NSManaged public func removeFromContainers(_ values: NSOrderedSet)

}

extension Page : Identifiable {

}
