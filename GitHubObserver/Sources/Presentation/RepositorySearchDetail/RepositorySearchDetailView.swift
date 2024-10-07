//
//  RepositorySearchDetailView.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 10/7/24.
//

import SwiftUI

import SwiftUI
import WebKit

struct RepositorySearchDetailView: View {
    var url: String
    
    public var body: some View {
        WebView(url: url)
    }
}

struct WebView: UIViewRepresentable {
    var url: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let webView = WKWebView()

        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
}

#Preview {
    RepositorySearchDetailView(url: "https://www.naver.com")
}
