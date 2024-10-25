//
//  ExtractString.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 10/16/24.
//

import Foundation

func extractCode(from url: URL) -> String? {
    if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
        return components.queryItems?.first(where: { $0.name == "code" })?.value
    }
    
    return nil
}

func extractAccessToken(from urlString: String) -> String? {
    if let components = URLComponents(string: "?\(urlString)") {
        return components.queryItems?.first(where: { $0.name == "access_token" })?.value
    }
    return nil
}
