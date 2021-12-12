//
//  ContentView.swift
//  Web Grid
//
//  Created by Umur Gedik on 8.12.2021.
//

import SwiftUI

struct ContentView: View {
    let storageProvider: StorageProvider
    
    @State var sidebarSelection: SidebarItem?
    @State var isErrorPresented = false
    @State var errorMessage = "" {
        didSet { isErrorPresented = !errorMessage.isEmpty }
    }
    
    var body: some View {
        NavigationView {
            Sidebar(storageProvider: storageProvider, selection: $sidebarSelection) 
            Color.clear
        }
        .navigationViewStyle(.columns)
        .environment(\.managedObjectContext, storageProvider.persistentContainer.viewContext)
        .alert(errorMessage, isPresented: $isErrorPresented) {
            Button("Okay", role: .cancel) { }
        }
    }    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
