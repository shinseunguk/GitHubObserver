//
//  ReadJson.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/27/24.
//

import Foundation

func getAuthorization() -> String {
    // 1. 불러올 파일 이름
    let fileNm: String = "APIConfig"
    // 2. 불러올 파일의 확장자명
    let extensionType = "json"
    
    // 3. 파일 위치
    guard let fileLocation = Bundle.main.url(forResource: fileNm, withExtension: extensionType) else { return "" }
    
    do {
        // 4. 해당 위치의 파일을 Data로 초기화하기
        let data = try Data(contentsOf: fileLocation)
        guard let header = try? JSONDecoder().decode(GithubHeader.self, from: data) else { return "" }
        
        return header.Authorization
    } catch {
        // catch
        return ""
    }
}
