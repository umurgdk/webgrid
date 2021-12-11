//
//  Web_GridApp.swift
//  Web Grid
//
//  Created by Umur Gedik on 16.11.2021.
//

import SwiftUI

@main
struct Web_GridApp: App {
    let storageProvider = StorageProvider()
    @State var newURLString = "https://apple.com"
    @State var url = URL(string: "https://apple.com")!
    
    @FocusedValue(\.page)
    private var focusedPage: Page?
    
    @State var invalidURLError = false
    @State var storageError: Error? {
        didSet { isStorageErrorPresented = storageError != nil }
    }
    @State var isStorageErrorPresented = false
    
    init() {
//        try! storageProvider.removeAll()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(storageProvider: storageProvider)
                .alert(storageError?.localizedDescription ?? "", isPresented: $isStorageErrorPresented) {
                    Button("Okay", role: .cancel) { }
                }
                .environment(\.storageProvider, storageProvider)
        }.commands {
            CommandMenu("Browser") {
                Button("Reload") {
                    focusedPage?.reloadContainers()
                }.keyboardShortcut("r")
            }
        }
    }
}
