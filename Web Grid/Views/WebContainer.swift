//
//  WebContainer.swift
//  Web Grid
//
//  Created by Umur Gedik on 16.11.2021.
//

import SwiftUI

struct WebContainer: View {
    @ObservedObject var container: Container
    let reloadToken: Int
    let url: URL
    
    var deviceSize: CGSize {
        container.device.size(from: container.orientation)
    }
    
    init(container: Container, url: URL, reloadToken: Int) {
        self._container = ObservedObject(initialValue: container)
        self.reloadToken = reloadToken
        self.url = url
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(spacing: 8) {
                Picker("", selection: $container.device) {
                    ForEach(Device.allCases) { device in
                        Text(device.rawValue).tag(device)
                    }
                }
                .fixedSize()
                
                Rectangle()
                    .fill(.quaternary)
                    .frame(width: 16, height: 1)
                
                Picker("", selection: $container.orientation) {
                    ForEach(Orientation.allCases) { orientation in
                        Text(orientation.rawValue).tag(orientation)
                    }
                }.fixedSize()
            }
            
            WebView(url: url, reloadToken: reloadToken)
                .frame(width: deviceSize.width, height: deviceSize.height)
                .cornerRadius(8)
                .padding(4)
                .background(.quaternary)
                .cornerRadius(10)
        }
        .fixedSize()
    }
}

//struct WebContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        let container = Container(device: .iPhone13Mini, orientation: .portrait, url: URL(string: "http://localhost:3000")!)
//        WebContainer(container: .constant(container), reloadToken: 1)
//    }
//}
