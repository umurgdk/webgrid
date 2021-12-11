//
//  WebView.swift
//  Web Grid
//
//  Created by Umur Gedik on 16.11.2021.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL
    let reloadToken: Int
    
    func makeNSView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        view.load(URLRequest(url: url))
        return view
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        if nsView.url == url {
            nsView.reload()
        } else {
            nsView.load(URLRequest(url: url))
        }
    }
}
