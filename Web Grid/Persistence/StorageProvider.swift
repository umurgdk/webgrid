//
//  StorageProvider.swift
//  Web Grid
//
//  Created by Umur Gedik on 7.12.2021.
//

import Foundation
import CoreData

class StorageProvider {
    public let persistentContainer: NSPersistentContainer
    
    #if DEBUG
    private static var instanceCount = 0
    #endif
    
    public init() {
        self.persistentContainer = NSPersistentContainer(name: "WebGrid")
        self.persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("CoreData failed to load with error: \(error.localizedDescription)")
            }
        }
        
        #if DEBUG
        Self.instanceCount += 1
        if Self.instanceCount > 1 {
            fatalError("StorageProvider created more than once!")
        }
        #endif
    }
    
    public func managedObjectID(forURIRepresentation uri: URL) -> NSManagedObjectID? {
        persistentContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: uri)
    }
    
    public func removeAll() throws {
        let context = persistentContainer.viewContext
        
        let containers = try context.fetch(Container.fetchRequest())
        containers.forEach { context.delete($0) }
        
        let pages = try context.fetch(Page.fetchRequest())
        pages.forEach { context.delete($0) }
        
        let sites = try context.fetch(Site.fetchRequest())
        sites.forEach { context.delete($0) }
        
        try context.save()
    }
    
    public func saveChanges(rollbackOnFailure: Bool = true) throws {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            throw error
        }
    }
    
    public func saveSite(title: String = "New Site") throws -> Site {
        let site = Site(context: persistentContainer.viewContext)
        site.title = title
        try saveChanges()
        return site
    }
    
    public func savePage(title: String? = "New Page", in site: Site) throws -> Page {
        let page = Page(context: persistentContainer.viewContext)
        page.title = "New Page"
        page.url = URL(string: "https://apple.com")!
        
        site.addToPages(page)

        try saveChanges()
        return page
    }
    
    public func deleteSite(_ site: Site) throws {
        persistentContainer.viewContext.delete(site)
        try saveChanges()
    }
    
    public func deletePage(_ page: Page) throws {
        persistentContainer.viewContext.delete(page)
        try saveChanges()
    }
    
    public func saveContainer(device: Device, orientation: Orientation) throws -> Container {
        let container = Container(context: persistentContainer.viewContext)
        container.device = device
        container.orientation = orientation
        
        do {
            try persistentContainer.viewContext.save()
            return container
        } catch {
            persistentContainer.viewContext.rollback()
            throw error
        }
    }
}
