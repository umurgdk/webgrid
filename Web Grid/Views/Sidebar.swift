//
//  Sidebar.swift
//  Web Grid
//
//  Created by Umur Gedik on 8.12.2021.
//

import SwiftUI
import CoreData

enum SidebarItem: Hashable {
    case site(Site)
    case page(Page)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .site(let site): hasher.combine(site.id)
        case .page(let page): hasher.combine(page.id)
        }
    }
}

struct Sidebar: View {
    let storageProvider: StorageProvider
    @Binding var selection: SidebarItem?
    
    @FetchRequest(fetchRequest: Site.sortedFetchRequest(), animation: .default)
    private var sites: FetchedResults<Site>
    
    @ObjectIDSetAppStorage("expandedSites")
    private var expandedSites: Set<NSManagedObjectID>
    
    @ObjectIDAppStorage("lastSelectedPage")
    private var lastSelectedPageID: NSManagedObjectID?
    
    private var lastSelectedPage: Page? {
        guard let pageID = lastSelectedPageID else { return nil }
        return sites.lazy.flatMap(\.pages).first(where: { $0.objectID == pageID })
    }
    
    @Namespace var sidebarNamespace
    
    @State var renamingText = ""
    @State var renamingItem: SidebarItem? {
        didSet {
            switch renamingItem {
            case .site(let site): renamingText = site.title
            case .page(let page): renamingText = page.title
            default: renamingText = ""
            }
        }
    }
    @State var isErrorPresented = false
    @State var errorMessage = "" {
        didSet { isErrorPresented = !errorMessage.isEmpty }
    }
    
    func isExpandedBinding(for site: Site) -> Binding<Bool> {
        Binding {
            expandedSites.contains(site.objectID)
        } set: { isExpanded in
            if isExpanded {
                expandedSites.insert(site.objectID)
            } else {
                expandedSites.remove(site.objectID)
            }
        }
    }
    
    func isActiveBinding(for page: Page) -> Binding<Bool> {
        Binding {
            selection == .page(page)
        } set: { newValue in
            if newValue {
                selection = .page(page)
            }
        }
    }
    
    func isEditingBinding(for item: SidebarItem) -> Binding<Bool> {
        Binding {
            renamingItem == item
        } set: { isEditing in
            renamingItem = isEditing ? item : nil
        }
    }
    
    var body: some View {
        List(sites, selection: $selection) { site in
            DisclosureGroup(isExpanded: isExpandedBinding(for: site)) {
                ForEach(site.pages) { page in
                    NavigationLink(destination: PageView(storageProvider: storageProvider, page: page),
                                   isActive: isActiveBinding(for: page)) {
                        EditableLabel(id: page.id,
                                      text: page.title,
                                      isEditing: isEditingBinding(for: .page(page)),
                                      editingText: $renamingText,
                                      iconName: "doc",
                                      focusNamespace: sidebarNamespace,
                                      onSubmit: commitPageRename)
                    }
                    .contextMenu {
                        Button("Rename") { renamingItem = .page(page) }
                        Button("Delete") { deletePage(page) }
                    }.tag(SidebarItem.page(page))
                }
            } label: {
                EditableLabel(id: site.id,
                              text: site.title,
                              isEditing: isEditingBinding(for: .site(site)),
                              editingText: $renamingText,
                              iconName: "folder",
                              focusNamespace: sidebarNamespace,
                              onSubmit: commitSiteRename)
                    .contextMenu {
                        Button("Rename") { renamingItem = .site(site) }
                        Button("Delete") { deleteSite(site) }
                    }
            }.tag(SidebarItem.site(site))
        }
        .onAppear { selection = lastSelectedPage.map(SidebarItem.page) }
        .toolbar {
            ToolbarItem { Spacer() }
            ToolbarItem(placement: .automatic) {
                Menu {
                    Button("New Page", action: addNewPage)
                    Button("New Site", action: addNewSite)
                } label: {
                    Label("Create", systemImage: "plus")
                }
            }
        }
        .alert(errorMessage, isPresented: $isErrorPresented) {
            Button("Okay", role: .cancel) { }
        }.focusScope(sidebarNamespace)
    }
    
    func deletePage(_ page: Page) {
        let pageID = page.id
        do {
            try storageProvider.deletePage(page)
            if case let .page(page) = selection, page.id == pageID {
                selection = page.site.pages.first.map(SidebarItem.page)
            }
        } catch {
            errorMessage = "Failed to delete page"
        }
    }
    
    func deleteSite(_ site: Site) {
        let siteID = site.id
        do {
            try storageProvider.deleteSite(site)
            if case let .site(site) = selection, site.id == siteID {
                selection = sites.first?.pages.first.map(SidebarItem.page)
            }
        } catch {
            errorMessage = "Failed to delete site"
        }
    }
    
    func commitPageRename() {
        guard case let .page(page) = renamingItem, !renamingText.isEmpty else { return }
        
        page.title = renamingText
        try? storageProvider.saveChanges()
        renamingItem = nil
    }
    
    func commitSiteRename() {
        guard case let .site(site) = renamingItem, !renamingText.isEmpty else { return }
        site.title = renamingText
        try? storageProvider.saveChanges()
        renamingItem = nil
    }
    
    func addNewSite() {
        do {
            let site = try storageProvider.saveSite()
            selection = .site(site)
            renamingItem = selection
        } catch {
            errorMessage = "Failed to create a new page"
        }
    }
    
    func addNewPage() {
        guard case .site(let site) = selection else { return }
        do {
            let page = try storageProvider.savePage(in: site)
            selection = .page(page)
            renamingItem = selection
        } catch {
            errorMessage = "Failed to create a new page"
        }
    }
}

//struct Sidebar_Previews: PreviewProvider {
//    static var previews: some View {
//        Sidebar()
//    }
//}
