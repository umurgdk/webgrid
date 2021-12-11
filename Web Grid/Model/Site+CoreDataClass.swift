//
//  Site+CoreDataClass.swift
//  Web Grid
//
//  Created by Umur Gedik on 11.12.2021.
//
//

import Foundation
import CoreData

@objc(Site)
public class Site: NSManagedObject {
    class func sortedFetchRequest() -> NSFetchRequest<Site> {
        let request = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Site.title, ascending: true)]
        return request
    }
}
