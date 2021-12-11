//
//  Page+CoreDataProperties.swift
//  Web Grid
//
//  Created by Umur Gedik on 8.12.2021.
//
//

import Foundation
import CoreData


extension Page {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }
    
    class func sortedFetchRequest() -> NSFetchRequest<Page> {
        let request = fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Page.order, ascending: true)
        ]
        return request
    }

    @NSManaged var title: String
    @NSManaged var containers: [Container]
    @NSManaged var url: URL
    @NSManaged var order: Int32
}

// MARK: Generated accessors for containers
extension Page {

    @objc(insertObject:inContainersAtIndex:)
    @NSManaged func insertIntoContainers(_ value: Container, at idx: Int)

    @objc(removeObjectFromContainersAtIndex:)
    @NSManaged func removeFromContainers(at idx: Int)

    @objc(insertContainers:atIndexes:)
    @NSManaged func insertIntoContainers(_ values: [Container], at indexes: NSIndexSet)

    @objc(removeContainersAtIndexes:)
    @NSManaged func removeFromContainers(at indexes: NSIndexSet)

    @objc(replaceObjectInContainersAtIndex:withObject:)
    @NSManaged func replaceContainers(at idx: Int, with value: Container)

    @objc(replaceContainersAtIndexes:withContainers:)
    @NSManaged func replaceContainers(at indexes: NSIndexSet, with values: [Container])

    @objc(addContainersObject:)
    @NSManaged func addToContainers(_ value: Container)

    @objc(removeContainersObject:)
    @NSManaged func removeFromContainers(_ value: Container)

    @objc(addContainers:)
    @NSManaged func addToContainers(_ values: NSOrderedSet)

    @objc(removeContainers:)
    @NSManaged func removeFromContainers(_ values: NSOrderedSet)

}

extension Page : Identifiable {

}
