//
//  AppDelegate.swift
//  Web Grid
//
//  Created by Umur Gedik on 12.12.2021.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var storageProvider: StorageProvider?
    
    func applicationDidHide(_ notification: Notification) {
        try? storageProvider?.saveChanges()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        try? storageProvider?.saveChanges()
    }
}
