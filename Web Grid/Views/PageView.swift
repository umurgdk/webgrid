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
    @FetchRequest var containers: FetchedResults<Container>
    
    @ObjectIDAppStorage("lastSelectedPage")
    private var lastSelectedPageID: NSManagedObjectID?
    
    init(storageProvider: StorageProvider, page: Page) {
        self.storageProvider = storageProvider
        self._page = ObservedObject(initialValue: page)
        self._newURLString = State(initialValue: page.url.absoluteString)
        _containers = FetchRequest(fetchRequest: page.containersFetchRequest(), animation: .default)
    }
    
    @State var newURLString: String
    @State var reloadToken: Int = 0
    
    @State var isErrorVisible: Bool = false
    @State var errorMessage: String = "" {
        didSet { isErrorVisible = !errorMessage.isEmpty }
    }
    
    @State var zoom: CGFloat = 1
    @State var lastZoomValue: CGFloat = 1
    var magnificationGesture: some Gesture {
        MagnificationGesture().onChanged { magnification in
            let delta = magnification / lastZoomValue
            lastZoomValue = magnification
            zoom *= delta
        }.onEnded { _ in
            lastZoomValue = 1
        }
    }
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            HStack(alignment: .top) {
                ForEach(containers) { container in
                    WebContainer(container: container, reloadToken: reloadToken, url: page.url, zoom: zoom) {
                        try? storageProvider.deleteContainer(container, in: page)
                    }
                    .padding()
                }
            }
            .frame(maxHeight: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(magnificationGesture)
        .focusedValue(\.page, page)
        .alert(errorMessage, isPresented: $isErrorVisible) {
            Button("Okay", role: .cancel) { }
        }
        .onAppear { lastSelectedPageID = page.objectID }
        .navigationTitle(page.title)
        .toolbar {
            ToolbarItemGroup {
                TextField("URL", text: $newURLString)
                    .frame(minWidth: 300, maxWidth: .infinity, alignment: .center)
                    .onSubmit(of: SubmitTriggers.text, updatePageURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Menu {
                    ForEach(Device.allCases) { device in
                        Button(device.rawValue) { addContainer(device: device) }
                    }
                } label: {
                    Label("Add container", systemImage: "plus")
                }
            }
            
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                }
            }
        }
    }
    
    func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    func addContainer(device: Device) {
        do {
            try storageProvider.saveContainer(device: device, orientation: .portrait, in: page)
        } catch {
            errorMessage = "Failed to create a new container"
            isErrorVisible = true
        }
    }
    
    func updatePageURL() {
        var urlString = newURLString
        if !urlString.hasPrefix("http://") && !urlString.hasPrefix("https://") {
            urlString = "http://" + urlString
        }
        
        newURLString = urlString
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
