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
}

extension GitHubAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com/")!
    }
    
    var path: String {
        switch self {
        case .searchRepositories:
            return "search/repositories"
        }
    }
    
    var method: Moya.Method {
        return .get
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
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json",
            "Authorization": getAuthorization()
        ]
    }
}
