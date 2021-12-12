//
//  ContentView.swift
//  Web Grid
//
//  Created by Umur Gedik on 16.11.2021.
//

import SwiftUI

struct PageView: View {
    let storageProvider: StorageProvider
    @ObservedObject var page: Page
    
    @ObjectIDAppStorage("lastSelectedPage")
    private var lastSelectedPageID: NSManagedObjectID?
    
    init(storageProvider: StorageProvider, page: Page) {
        self.storageProvider = storageProvider
        self._page = ObservedObject(initialValue: page)
        self._newURLString = State(initialValue: page.url.absoluteString)
    }
    
    @State var newURLString: String
    @State var reloadToken: Int = 0
    
    @State var isErrorVisible: Bool = false
    @State var errorMessage: String = "" {
        didSet { isErrorVisible = !errorMessage.isEmpty }
    }
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            HStack(alignment: .top) {
                ForEach(page.containers) { container in
                    WebContainer(container: container, reloadToken: reloadToken, url: page.url) {
                        try? storageProvider.deleteContainer(container, in: page)
                    }.padding()
                }
            }
            .frame(maxHeight: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .focusedValue(\.page, page)
        .alert(errorMessage, isPresented: $isErrorVisible) {
            Button("Okay", role: .cancel) { }
        }
        .onAppear { lastSelectedPageID = page.objectID }
        .navigationTitle(page.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                TextField("URL", text: $newURLString)
                    .onSubmit(of: SubmitTriggers.text, updatePageURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 300)
            }
            
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    ForEach(Device.allCases) { device in
                        Button(device.rawValue) { addContainer(device: device) }
                    }
                } label: {
                    Label("Add container", systemImage: "plus")
                }
            }
        }
    }
    
    func addContainer(device: Device) {
        do {
            let container = try storageProvider.saveContainer(device: device, orientation: .portrait)
            page.addToContainers(container)
            try storageProvider.saveChanges(rollbackOnFailure: true)
        } catch {
            errorMessage = "Failed to create a new container"
            isErrorVisible = true
        }
    }
    
    func updatePageURL() {
        guard let url = URL(string: newURLString) else {
            errorMessage = "Please make sure url is valid"
            isErrorVisible = true
            return
        }
        
        page.url = url
        try! storageProvider.saveChanges()
    }
    
}

//struct PageView_Previews: PreviewProvider {
//    static var previews: some View {
//        let model = ApplicationModel()
//        model.addContainer(device: .iPhone13Mini, orientation: .portrait, url: URL(string: "http://localhost:3000")!)
//
//        return PageView(appModel: model)
//    }
//}
