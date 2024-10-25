//
//  GitHubAPI.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/23/24.
//

import Moya
import Foundation

// Define the GitHub API target
enum GitHubAPI {
    case searchRepositories(query: String, page: Int)
    case accessToken(code: String)
    case myInfo(token: String)
    case myRepos(ownerId: String)
}

extension GitHubAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .accessToken:
            return URL(string: "https://github.com/")!
        default:
            return URL(string: "https://api.github.com/")!
        }
    }
    
    var path: String {
        switch self {
        case .searchRepositories:
            return "search/repositories"
        case .accessToken:
            return "login/oauth/access_token"
        case .myInfo:
            return "user"
        case .myRepos(let ownerId):
            return "users/\(ownerId)/repos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchRepositories:
            return .get
        case .accessToken:
            return .post
        case .myInfo:
            return .get
        case .myRepos:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case let .searchRepositories(query, page):
            return .requestParameters(
                parameters: [
                    "q": query,
                    "page": page
                ],
                encoding: URLEncoding.default
            )
        case let .accessToken(code):
            return .requestParameters(
                parameters: [
                    "client_id": Bundle.main.CLIENT_ID,
                    "client_secret": Bundle.main.CLIENT_SERCRET,
                    "code" : code
                ],
                encoding: URLEncoding.default
            )
        case .myInfo:
            return .requestParameters(
                parameters: [
                    "client_secret": Bundle.main.CLIENT_SERCRET
                ],
                encoding: URLEncoding.default
            )
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .myInfo(token):
            return [
                "Authorization": "token \(token)"
            ]
        default:
            return [:]
        }
    }
}
