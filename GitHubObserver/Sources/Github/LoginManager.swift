//
//  LoginManager.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 10/11/24.
//

import Foundation
import KeychainSwift
import Alamofire
import UIKit

enum ApiPath: String {
    case LOGIN = "/login/oauth/authorize" // 사용자의 깃허브 아이디 (사파리 페이지 이동)
    case ACCESS_TOKEN = "/login/oauth/access_token" // access token 요청
    case USER = "/user" // 유저 정보
    case REPOS = "/user/repos" // 유저 레포지토리 정보
}

class LoginManager {
    
    static let shared = LoginManager()
    
    private let client_id: String = "Ov23lib1i90HJqGFqf1Q"
    private let client_secret: String = "192d2ab094e7dd353fde0dfb174b79d711f8e043"
    private let scope: String = "repo gist user"
    private let githubURL: String = "https://github.com"
    private let githubApiURL: String = "https://api.github.com"
    
    func requestCode() {
        var components = URLComponents(string: githubURL + ApiPath.LOGIN.rawValue)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: self.client_id),
            URLQueryItem(name: "scope", value: self.scope),
        ]
        
        print(components)
        let urlString = components.url?.absoluteString
        if let url = URL(string: urlString!), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
        }
    }
    
    func requestAccessToken(with code: String) {
            let parameters = ["client_id": client_id,
                              "client_secret": client_secret,
                              "code": code]
            
            let headers: HTTPHeaders = ["Accept": "application/json"]
            
        AF.request(githubURL+ApiPath.ACCESS_TOKEN.rawValue,
                   method: .post, parameters: parameters,
                   headers: headers).responseJSON { (response) in
                        switch response.result {
                        case let .success(json):
                            if let dic = json as? [String: String] {
                                let accessToken = dic["access_token"] ?? ""
                                KeychainSwift().set(accessToken, forKey: "accessToken")
                            }
                        case let .failure(error):
                            print(error)
                        }
                   }
        }
    
    func getUser() {
        let accessToken = KeychainSwift().get("accessToken") ?? ""
        let headers: HTTPHeaders = ["Accept": "application/vnd.github.v3+json",
                                    "Authorization": "token \(accessToken)"]

        AF.request(githubApiURL+ApiPath.USER.rawValue,
                   method: .get,
                   parameters: [:],
                   headers: headers).responseJSON(completionHandler: { (response) in
                        switch response.result {
                        case .success(let json):
                            print(json as! [String: Any])
                        case .failure:
                            print("")
                        }
                   })
    }
    
    func getRepos() {
        let accessToken = KeychainSwift().get("accessToken") ?? ""
        let headers: HTTPHeaders = ["Accept": "application/vnd.github.v3+json",
                                    "Authorization": "token \(accessToken)"]
        AF.request(githubApiURL+ApiPath.REPOS.rawValue,
                   method: .get, parameters: [:],
                   headers: headers).responseJSON(completionHandler: { (response) in
                        switch response.result {
                        case .success(let json):
                            print(json)
                        case .failure:
                            print("")
                        }
                   })
    }
    
    func logout() {
        KeychainSwift().clear()
    }
}
