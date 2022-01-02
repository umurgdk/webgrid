//
//  WebView.swift
//  Web Grid
//
//  Created by Umur Gedik on 16.11.2021.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable, Equatable {
    let url: URL
    let reloadToken: Int
    let zoom: CGFloat
    let deviceSize: CGSize
    
    func makeNSView(context: Context) -> ReloadableWebView {
        let view = ReloadableWebView()
        view.deviceSize = deviceSize
        view.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        view.load(URLRequest(url: url))
        view.reloadToken = reloadToken
        return view
    }
    
    func updateNSView(_ nsView: ReloadableWebView, context: Context) {
        if nsView.url != url {
            nsView.load(URLRequest(url: url))
        } else if reloadToken != nsView.reloadToken {
            nsView.reloadToken = reloadToken
            nsView.reload()
        }
        
        if deviceSize != nsView.deviceSize {
            nsView.deviceSize = deviceSize
        }
        
        if zoom != nsView.zoom {
            nsView.zoom = zoom
        }
    }
}

class ReloadableWebView: WKWebView {
    var reloadToken = 0
    var deviceSize: CGSize = .zero    
    var zoom: CGFloat = 1 {
        didSet {
            wantsLayer = true
            layer?.sublayerTransform = CATransform3DMakeScale(zoom, zoom, 1)
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: deviceSize.width * (1/zoom),
               height: deviceSize.height * (1/zoom))
    }
}

struct PreviewDemo: View {
    @State var zoom: CGFloat = 1
    let deviceSize = CGSize(width: 375, height: 400)
    
    var body: some View {
        VStack {
            WebView(url: URL(string: "https://apple.com")!,
                    reloadToken: 0,
                    zoom: zoom,
                    deviceSize: deviceSize)
                .frame(width: deviceSize.width,
                       height: deviceSize.height)
            
            Slider(value: $zoom, in: (0.5)...(1.5))
        }
    }
}

struct Previews_WebView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewDemo()
    }
}
