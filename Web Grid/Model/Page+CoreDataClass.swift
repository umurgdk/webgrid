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
    
    func appendContainer(_ container: Container) {
        let previousContainers = containers.sorted(by: { $0.order < $1.order })
        let lastContainerOrder = previousContainers.last?.order ?? 0
        
        container.order = lastContainerOrder + 1
        addToContainers(container)
        containers
            .sorted(by: {$0.order < $1.order})
            .enumerated()
            .forEach { order, container in container.order = Int16(order) }
    }
    
    func containersFetchRequest() -> NSFetchRequest<Container> {
        let request = Container.fetchRequest()
        request.predicate = NSPredicate(format: "page = %@", self)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Container.order, ascending: true)]
        return request
    }
}
