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
    let zoom: CGFloat
    let onDelete: () -> Void
    
    @State var hoveringActionBar = false
    @State var error: LocalizedError? = nil
    @State var isErrorPresented = false
    
    @Environment(\.colorScheme) var systemColorScheme
    
    var appearanceBinding: Binding<Appearance> {
        Binding {
            container.appearance ?? Appearance(from: systemColorScheme)
        } set: {
            container.appearance = $0
        }
    }
    
    var deviceSize: CGSize {
        container.device.size(from: container.orientation)
    }
    
    var scaledDeviceSize: CGSize {
        CGSize(width: deviceSize.width * zoom, height: deviceSize.height * zoom)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ContainerPicker(Device.allCases,
                                selection: $container.device,
                                title: \.rawValue,
                                icon: \.systemIconName)
                
                Circle()
                    .fill(.tertiary)
                    .frame(width: 4, height: 4)
                
                ContainerPicker(Orientation.allCases,
                                selection: $container.orientation,
                                title: \.rawValue)
                
                
                Circle()
                    .fill(.tertiary)
                    .frame(width: 4, height: 4)
                
                ContainerPicker(Appearance.allCases,
                                selection: appearanceBinding,
                                title: \.title,
                                icon: { $0.iconName(system: systemColorScheme) })
                    .showsTitleInSelection(false)
                
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
            .padding(.horizontal, 8)
            .frame(height: 32, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 8).fill(.quaternary).opacity(0.5))
            .onHover { isHovered in
                hoveringActionBar = isHovered
            }
            
            WebView(url: url, reloadToken: reloadToken, zoom: zoom, deviceSize: deviceSize)
                .fixedSize()
                .colorScheme(container.appearance?.colorScheme(system: systemColorScheme) ?? systemColorScheme)
                .animation(nil, value: scaledDeviceSize)
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
