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
    
    func makeNSView(context: Context) -> ReloadableWebView {
        let view = ReloadableWebView()
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
    }
}

class ReloadableWebView: WKWebView {
    var reloadToken = 0
}
