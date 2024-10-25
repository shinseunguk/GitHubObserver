//
//  SearchBar.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/11/24.
//

import SwiftUI

enum SearchBarConstants {
    static let placeholder = "Please enter repository".localized()
}

struct SearchBar: View {
    
    @Binding var text: String
    var onSubmit: (() -> Void)? // 추가: 클로저 선언
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField(SearchBarConstants.placeholder, text: $text, onCommit: {
                    onSubmit?() // 추가: onSubmit 클로저 호출
                })
                .foregroundColor(.primary)
                .autocapitalization(.none)
                .submitLabel(.search)
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
    }
}
