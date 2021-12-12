//
//  MenuTrigger.swift
//  Web Grid
//
//  Created by Umur Gedik on 12.12.2021.
//

import Foundation
import SwiftUI

struct MenuItem<ID: Hashable>: Identifiable {
    var id: ID
    var title: String
    var systemImageName: String?
    var action: (ID) -> Void
}

class MenuTriggerOverlayView<ItemID: Hashable>: NSView {
    var items: [MenuItem<ItemID>] {
        didSet { menu = nil }
    }
    
    var selectedItemID: ItemID?
    
    private var selectedMenuItem: NSMenuItem?
    private var menuItems: [NSMenuItem] = []
    
    init(items: [MenuItem<ItemID>]) {
        self.items = items
        super.init(frame: .zero)
        
        addGestureRecognizer(NSClickGestureRecognizer(target: self, action: #selector(didClick)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) has not been implemented")
    }
    
    @objc private func didClick(_ gestureRecognizer: NSGestureRecognizer) {
        if menu == nil {
            buildMenu()
        }
        
        guard let menu = menu else { return }
        menu.popUp(positioning: selectedMenuItem, at: .zero, in: self)
    }
    
    private func buildMenu() {
        let menu = NSMenu()
        menuItems = []
        items.forEach { item in
            let menuItem = NSMenuItem(title: item.title, action: #selector(didClickMenuItem), keyEquivalent: "")
            menuItem.target = self
            
            if let systemIconName = item.systemImageName {
                menuItem.image = NSImage(systemSymbolName: systemIconName, accessibilityDescription: nil)
            }
            
            menu.addItem(menuItem)
            
            if selectedItemID == item.id {
                selectedMenuItem = menuItem
            }
            
            menuItems.append(menuItem)
        }
        
        self.menu = menu
    }
    
    @objc private func didClickMenuItem(_ item: NSMenuItem) {
        guard let index = menuItems.firstIndex(of: item), items.indices.contains(index) else { return }
        let item = items[index]
        item.action(item.id)
    }
}

struct MenuTriggerOverlay<ItemID: Hashable>: NSViewRepresentable {
    let items: [MenuItem<ItemID>]
    
    func makeNSView(context: Context) -> MenuTriggerOverlayView<ItemID> {
        MenuTriggerOverlayView(items: items)
    }
    
    func updateNSView(_ nsView: MenuTriggerOverlayView<ItemID>, context: Context) {
        nsView.items = items
    }
}

struct MenuTrigger<ItemID: Hashable>: ViewModifier {
    let items: [MenuItem<ItemID>]
    func body(content: Content) -> some View {
        content.overlay(MenuTriggerOverlay(items: items))
    }
}

extension View {
    func menuTrigger<ItemID: Hashable>(items: [MenuItem<ItemID>]) -> some View {
        modifier(MenuTrigger(items: items))
    }
}
