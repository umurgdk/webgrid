//
//  StorageProvider+Environment.swift
//  Web Grid
//
//  Created by Umur Gedik on 11.12.2021.
//

import Foundation
import SwiftUI

struct StorageProviderEnvironmentKey: EnvironmentKey {
    typealias Value = StorageProvider?
    static var defaultValue: Value = nil
}

extension EnvironmentValues {
    var storageProvider: StorageProvider? {
        get { self[StorageProviderEnvironmentKey.self] }
        set { self[StorageProviderEnvironmentKey.self] = newValue }
    }
}
