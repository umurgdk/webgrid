//
//  ContainerPicker.swift
//  Web Grid
//
//  Created by Umur Gedik on 12.12.2021.
//

import SwiftUI

struct ContainerPicker<Item: Hashable & Identifiable>: View {
    let items: [Item]
    let title: (Item) -> String
    let icon: ((Item) -> String)?
    
    @Binding var selection: Item
    
    init(
        _ items: [Item],
        selection: Binding<Item>,
        title: @escaping (Item) -> String,
        icon: ((Item) -> String)? = nil
    ) {
        self.items = items
        self._selection = selection
        self.title = title
        self.icon = icon
    }
    
    var body: some View {
        HStack {
            if let icon = icon {
                Label(title(selection), systemImage: icon(selection))
            } else {
                Text(title(selection))
            }
            
            Image(systemName: "chevron.up.chevron.down")
                .foregroundColor(.secondary)
        }.menuTrigger(items: items.map { item in
            MenuItem(id: item.id,
                     title: title(item),
                     systemImageName: icon?(item),
                     action: selectItem)
        })
    }
    
    private func selectItem(_ itemID: Item.ID) {
        guard let item = items.first(where: { $0.id == itemID }) else { return }
        selection = item
    }
}

struct ContainerPicker_Previews: PreviewProvider {
    struct Item: Hashable, Identifiable {
        let title: String
        let iconName: String
        var id: String { title }
        
        static let iphone = Item(title: "iPhone", iconName: "iphone")
        static let ipad = Item(title: "iPad", iconName: "ipad")
        static let mac = Item(title: "MacBook Pro", iconName: "laptopcomputer")
        
        static let items = [iphone, ipad, mac]
    }
    
    static var previews: some View {
        var selection = Item.iphone
        let selectionBinding = Binding { selection } set: { selection = $0 }
        
        ContainerPicker(Item.items,
                        selection: selectionBinding,
                        title: { $0.title },
                        icon: { $0.iconName })
    }
}
