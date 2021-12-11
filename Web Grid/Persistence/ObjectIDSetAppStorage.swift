//
//  ObjectIDCollectionAppStorage.swift
//  Web Grid
//
//  Created by Umur Gedik on 11.12.2021.
//

import Foundation
import CoreData
import SwiftUI

@propertyWrapper struct ObjectIDSetAppStorage: DynamicProperty {
    private let key: String
    private let userDefaults: UserDefaults
    @Environment(\.storageProvider) var envStorageProvider
    private let preferredStorageProvider: StorageProvider?
    
    private var storageProvider: StorageProvider {
        if let provider = preferredStorageProvider ?? envStorageProvider {
            return provider
        }
        
        fatalError("No storage provider")
    }
    
    init(_ key: String, store: UserDefaults = .standard, storageProvider: StorageProvider? = nil) {
        self.key = key
        preferredStorageProvider = storageProvider
        self.userDefaults = store
    }
    
    var wrappedValue: Set<NSManagedObjectID> {
        get {
            guard let urlStrings = userDefaults.stringArray(forKey: key) else { return [] }
            let objectIDs = urlStrings
                .compactMap(URL.init(string:))
                .compactMap(storageProvider.managedObjectID(forURIRepresentation:))
            
            return Set(objectIDs)
        }
        
        nonmutating set {
            let urlStrings = newValue.map { $0.uriRepresentation().absoluteString }
            userDefaults.set(urlStrings, forKey: key)
        }
    }
}
