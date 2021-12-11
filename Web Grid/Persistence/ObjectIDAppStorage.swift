//
//  ObjectIDAppStorage.swift
//  Web Grid
//
//  Created by Umur Gedik on 11.12.2021.
//

import Foundation
import CoreData
import Combine
import SwiftUI

@propertyWrapper struct ObjectIDAppStorage: DynamicProperty {
    @AppStorage private var storedValue: String?
    @Environment(\.storageProvider) var envStorageProvider
    private let preferredStorageProvider: StorageProvider?
    
    private var storageProvider: StorageProvider {
        if let provider = preferredStorageProvider ?? envStorageProvider {
            return provider
        } else {
            fatalError("No storage provider")
        }
    }
    
    init(_ key: String, store: UserDefaults? = nil, storageProvider: StorageProvider? = nil) {
        preferredStorageProvider = storageProvider
        _storedValue = AppStorage(key, store: store)
    }
    
    var wrappedValue: NSManagedObjectID? {
        get {
            storedValue
                .flatMap(URL.init(string:))
                .flatMap { url in
                    storageProvider.managedObjectID(forURIRepresentation: url)
                }
        }
        
        nonmutating set {
            if let objectID = newValue {
                let url = objectID.uriRepresentation()
                storedValue = url.absoluteString
            } else {
                storedValue = nil
            }
        }
    }
}
