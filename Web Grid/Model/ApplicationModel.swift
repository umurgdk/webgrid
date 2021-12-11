//
//  ApplicationModel.swift
//  Web Grid
//
//  Created by Umur Gedik on 16.11.2021.
//

import Foundation

class ApplicationModel: ObservableObject {
    private let storageProvider: StorageProvider
    public init(storageProvider: StorageProvider) {
        self.storageProvider = storageProvider
    }
}
