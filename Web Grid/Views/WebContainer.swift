//
//  WebContainer.swift
//  Web Grid
//
//  Created by Umur Gedik on 16.11.2021.
//

import SwiftUI

struct WebContainer: View {
    @Environment(\.storageProvider) var storageProvider
    @ObservedObject var container: Container
    let reloadToken: Int
    let url: URL
    let onDelete: () -> Void
    
    @State var hoveringActionBar = false
    @State var error: LocalizedError? = nil
    @State var isErrorPresented = false
    
    var deviceSize: CGSize {
        container.device.size(from: container.orientation)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ContainerPicker(Device.allCases,
                                selection: $container.device,
                                title: { $0.rawValue },
                                icon: { $0.systemIconName })
                
                Circle()
                    .fill(.tertiary)
                    .frame(width: 4, height: 4)
                
                ContainerPicker(Orientation.allCases,
                                selection: $container.orientation,
                                title: { $0.rawValue })
                
                Spacer()
                
                if hoveringActionBar {
                    if container.canMoveLeft {
                        Button(action: container.moveLeft, label: { Image(systemName: "chevron.left") })
                            .buttonStyle(.borderless)
                    }
                    
                    if container.canMoveRight {
                        Button(action: container.moveRight, label: { Image(systemName: "chevron.right") })
                            .buttonStyle(.borderless)
                    }
                    
                    Button(action: onDelete, label: { Image(systemName: "trash") })
                        .buttonStyle(.borderless)
                }
            }
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 8).fill(.quaternary).opacity(0.5))
            .onHover { isHovered in
                hoveringActionBar = isHovered
            }
            
            WebView(url: url, reloadToken: reloadToken)
                .frame(width: deviceSize.width, height: deviceSize.height)
                .animation(nil, value: deviceSize)
                .cornerRadius(8)
                .padding(4)
                .background(.quaternary)
                .cornerRadius(10)
        }
        .alert(error?.localizedDescription ?? "", isPresented: $isErrorPresented) {
            Button("Okay", role: .cancel, action: { })
        }
    }
}

//struct WebContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        let container = Container(device: .iPhone13Mini, orientation: .portrait, url: URL(string: "http://localhost:3000")!)
//        WebContainer(container: .constant(container), reloadToken: 1)
//    }
//}
