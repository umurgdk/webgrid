//
//  Site+CoreDataProperties.swift
//  Web Grid
//
//  Created by Umur Gedik on 11.12.2021.
//
//

import Foundation
import CoreData


extension Site {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Site> {
        return NSFetchRequest<Site>(entityName: "Site")
    }

    @NSManaged var title: String
    @NSManaged var pages: [Page]

}

// MARK: Generated accessors for pages
extension Site {

    @objc(insertObject:inPagesAtIndex:)
    @NSManaged func insertIntoPages(_ value: Page, at idx: Int)

    @objc(removeObjectFromPagesAtIndex:)
    @NSManaged func removeFromPages(at idx: Int)

    @objc(insertPages:atIndexes:)
    @NSManaged func insertIntoPages(_ values: [Page], at indexes: NSIndexSet)

    @objc(removePagesAtIndexes:)
    @NSManaged func removeFromPages(at indexes: NSIndexSet)

    @objc(replaceObjectInPagesAtIndex:withObject:)
    @NSManaged func replacePages(at idx: Int, with value: Page)

    @objc(replacePagesAtIndexes:withPages:)
    @NSManaged func replacePages(at indexes: NSIndexSet, with values: [Page])

    @objc(addPagesObject:)
    @NSManaged func addToPages(_ value: Page)

    @objc(removePagesObject:)
    @NSManaged func removeFromPages(_ value: Page)

    @objc(addPages:)
    @NSManaged func addToPages(_ values: NSOrderedSet)

    @objc(removePages:)
    @NSManaged func removeFromPages(_ values: NSOrderedSet)

}

extension Site : Identifiable {

}
