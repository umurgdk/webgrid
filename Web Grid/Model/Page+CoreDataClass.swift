//
//  Page+CoreDataClass.swift
//  Web Grid
//
//  Created by Umur Gedik on 12.12.2021.
//
//

import Foundation
import CoreData

@objc(Page)
public class Page: NSManagedObject {
    @Published private var reloadToken: Int = Int.random(in: 0...1_000_000)
    public func reloadContainers() {
        reloadToken = Int.random(in: 0...1_000_000)
    }
    
    class func sortedFetchRequest() -> NSFetchRequest<Page> {
        let request = fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Page.title, ascending: true)]
        return request
    }
}
