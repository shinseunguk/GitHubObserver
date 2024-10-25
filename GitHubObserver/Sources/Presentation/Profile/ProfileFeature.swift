//
//  ProfileFeature.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 10/10/24.
//

import Foundation
import ComposableArchitecture
import UIKit

struct ProfileFeature: Reducer {
    
    private let githubService = GitHubService()
    private let userDefaults = AppUserDefaults.shared
    
    struct State: Equatable {
        var showingAlert: Bool = false
        var owner: Owner?
        var ownerId: String?
        var repostiory: [Item]?
        var isLoading: Bool = true
    }
    
    enum Action {
        case checkLogin
        case onAppear
        case setAlertDismissed
        case goToGitHubPage
        case setShowingAlert
        case logout
        case fetchError(error: GitHubError)
        case openURLReceived(URL)
        case requestMyInfo(token: String)
        case responseMyInfo(owner: Owner)
        case responseRepos(item: [Item])
        case itemTapped(item: Item)
    }
    
    enum ID: Hashable {
        case debounce, throttle
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .checkLogin:
            guard let owner = userDefaults.getOwner() else {
                return .none
            }
            state.owner = owner
            return .none
        case .onAppear:
            guard let token = userDefaults.getToken() else {
                state.owner = nil
                state.repostiory = nil
                state.showingAlert = true
                return .none
            }
            
            let requestMyInfo = githubService.requestMyInfo(token: token)
                .debounce(
                    id: ID.debounce,
                    for: 2.0,
                    scheduler: DispatchQueue.main
                )
                .cancellable(id: ID.debounce) // 동일한 debounce ID를 사용하여 중복 요청 방지
            
            if let owner = userDefaults.getOwner() {
                state.owner = owner
            }
            
            return requestMyInfo
        case .setAlertDismissed:
            state.showingAlert = false
            return .none
        case .goToGitHubPage:
            print("goToGitHubPage")
            requestCode()
            return .none
        case .setShowingAlert:
            state.showingAlert = true
            return .none
        case .logout:
            userDefaults.removeOwner()
            userDefaults.removeToken()
            
            state.owner = nil
            state.ownerId = nil
            state.repostiory = nil
            
            print(".logout")
            return .none
        case .fetchError(let error):
            print("🚨 \(#file) \(#line) \(#function) \(error)")
            return .none
        case .openURLReceived(let url):
            guard let codeString = extractCode(from: url) else {
                return .none
            }
                return githubService.requestAccessToken(code: codeString)
                    .debounce(
                        id: ID.debounce,
                        for: 2.0,
                        scheduler: DispatchQueue.main
                    )
                    .cancellable(id: ID.debounce) // 동일한 debounce ID를 사용하여 중복 요청 방지
        case .requestMyInfo(let token):
            state.isLoading = true
            userDefaults.setToken(token)
            return githubService.requestMyInfo(token: token)
                .debounce(
                    id: ID.throttle,
                    for: 2.0,
                    scheduler: DispatchQueue.main
                )
                .cancellable(id: ID.throttle) // 동일한 debounce ID를 사용하여 중복 요청 방지
        case .responseMyInfo(let owner):
            userDefaults.setOwner(owner)
            state.owner = owner
            state.ownerId = owner.login
            return githubService.requestMyRepository(ownerId: state.ownerId ?? "")
                .debounce(
                    id: ID.throttle,
                    for: 2.0,
                    scheduler: DispatchQueue.main
                )
                .cancellable(id: ID.throttle) // 동일한 debounce ID를 사용하여 중복 요청 방지
        case .responseRepos(let item):
            state.isLoading = false
            state.repostiory = item
            return .none
        case .itemTapped(let item):
            if let url = item.htmlURL { // 아이템에서 URL 가져오기
                if let url = URL(string: url) {
                    UIApplication.shared.open(url) // 웹 브라우저 열기
                }
            }
            return .none
        }
    }
    
    func requestCode() {
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Bundle.main.CLIENT_ID),
            URLQueryItem(name: "scope", value: "repo gist user"),
        ]
        
        let urlString = components.url?.absoluteString
        if let url = URL(string: urlString!), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
        }
    }
}

