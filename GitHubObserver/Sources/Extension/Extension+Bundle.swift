//
//  Extension+Bundle.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/27/24.
//

import Foundation

extension Bundle {
    var GITHUB_API_KEY: String {
        guard let file = self.path(forResource: "GitHubInfo", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["GITHUB_API_KEY"] as? String else {
            fatalError("GITHUB_API_KEY error")
        }
        return key
    }
    
    var CLIENT_ID: String {
        guard let file = self.path(forResource: "GitHubInfo", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["CLIENT_ID"] as? String else {
            fatalError("CLIENT_ID")
        }
        return key
    }
    
    var CLIENT_SERCRET: String {
        guard let file = self.path(forResource: "GitHubInfo", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["CLIENT_SERCRET"] as? String else {
            fatalError("CLIENT_SERCRET")
        }
        return key
    }
}
