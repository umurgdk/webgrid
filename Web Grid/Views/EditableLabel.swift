//
//  EditableLabel.swift
//  Web Grid
//
//  Created by Umur Gedik on 11.12.2021.
//

import SwiftUI

struct EditableLabel<ID: Hashable>: View {
    let id: ID
    let text: String
    @Binding var isEditing: Bool
    @Binding var editingText: String
    let iconName: String
    let focusNamespace: Namespace.ID
    let onSubmit: () -> Void
    
    var body: some View {
        Label {
            if isEditing {
                TextField("", text: $editingText)
                    .prefersDefaultFocus(in: focusNamespace)
                    .onSubmit(of: .text, onSubmit)
                    .onExitCommand { isEditing = false }
                    .id(id)
            } else {
                Text(text)
            }
        } icon: {
            Image(systemName: iconName)
        }
    }
}

struct EditableLabel_Previews: PreviewProvider {
    static var previews: some View {
        EditableLabel(id: 1,
                      text: "umurgdk.dev",
                      isEditing: .constant(true),
                      editingText: .constant("umurgdk.dev"),
                      iconName: "doc",
                      focusNamespace: Namespace().wrappedValue,
                      onSubmit: { })
    }
}
