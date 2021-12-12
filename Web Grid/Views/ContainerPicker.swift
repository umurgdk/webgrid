//
//  ContainerPicker.swift
//  Web Grid
//
//  Created by Umur Gedik on 12.12.2021.
//

import SwiftUI

fileprivate struct PickerConfiguration {
    var showsTitleInSelection = true
}

fileprivate struct PickerConfigurationKey: EnvironmentKey {
    static var defaultValue = PickerConfiguration()
}

fileprivate extension EnvironmentValues {
    var pickerConfiguration: PickerConfiguration {
        get { self[PickerConfigurationKey.self] }
        set { self[PickerConfigurationKey.self] = newValue }
    }
}

extension ContainerPicker {
    func showsTitleInSelection(_ shows: Bool) -> some View {
        var configuration = self.configuration
        configuration.showsTitleInSelection = shows
        return self.environment(\.pickerConfiguration, configuration)
    }
}

struct ContainerPicker<Item: Hashable & Identifiable>: View {
    let items: [Item]
    let title: ((Item) -> String)?
    let icon: ((Item) -> String)?
    
    @Binding var selection: Item
    
    @Environment(\.pickerConfiguration) private var configuration
    
    init(
        _ items: [Item],
        selection: Binding<Item>,
        title: @escaping (Item) -> String,
        icon: @escaping (Item) -> String
    ) {
        self.items = items
        self._selection = selection
        self.title = title
        self.icon = icon
    }
    
    init(_ items: [Item], selection: Binding<Item>, title: @escaping (Item) -> String) {
        self.items = items
        self._selection = selection
        self.title = title
        self.icon = nil
    }
        
    init(_ items: [Item], selection: Binding<Item>, icon: @escaping (Item) -> String) {
        self.items = items
        self._selection = selection
        self.icon = icon
        self.title = nil
    }
    
    var body: some View {
        HStack {
            if let icon = icon, let title = title, configuration.showsTitleInSelection {
                Label(title(selection), systemImage: icon(selection))
            } else if let title = title, configuration.showsTitleInSelection {
                Text(title(selection))
            } else if let icon = icon {
                Image(systemName: icon(selection))
            }
            
            Image(systemName: "chevron.up.chevron.down")
                .foregroundColor(.secondary)
        }.menuTrigger(items: items.map { item in
            MenuItem(id: item.id,
                     title: title?(item),
                     systemImageName: icon?(item))
        }, action: selectItem)
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
