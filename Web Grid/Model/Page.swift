//
//  Page+CoreDataClass.swift
//  Web Grid
//
//  Created by Umur Gedik on 8.12.2021.
//
//

import Foundation
import CoreData

@objc(Page)
class Page: NSManagedObject {
    @Published private var reloadToken: Int = Int.random(in: 0...1_000_000)
    public func reloadContainers() {
        reloadToken = Int.random(in: 0...1_000_000)
    }
}
