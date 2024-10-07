//
//  RepositorySearchFeature.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/12/24.
//

import Foundation
import ComposableArchitecture
import Moya
import UIKit

struct RepositorySearchFeature: Reducer {
    
    private let githubService = GitHubService()
    
    struct State: Equatable {
        var text = ""
        var repositories: SearchRepository = SearchRepository(totalCount: 0, incompleteResults: false, items: [])
        
        var totalCount = 0
        var items: [Item]?
        var page = 1
        
        var isLoading = false
        
        var showingError: Bool = false
        var errorMessage: String = ""
    }
    
    enum Action {
        case didChangeText(text: String)
        case searchButtonTapped
        case scrollToBottom
        case fetchRepositoriesResponse(result: SearchRepository)
        case fetchError(error: GitHubError)
        case itemTapped(item: Item)  // 아이템 클릭 이벤트 추가
        case dismissError
    }
    
    enum ID: Hashable {
        case debounce, throttle
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .didChangeText(let text):
            state.text = text
            return .none
        case .searchButtonTapped:
            state.isLoading = true
            state.items = nil
            state.page = 1
            return githubService.searchRepositories(query: state.text, page: state.page)
                .debounce(
                    id: ID.debounce,
                    for: 2.0,
                    scheduler: DispatchQueue.main
                )
                .cancellable(id: ID.debounce) // 동일한 debounce ID를 사용하여 중복 요청 방지
                .eraseToEffect() // Effect로 변환
        case .scrollToBottom:
            state.isLoading = true
            state.page += 1
            return githubService.searchRepositories(query: state.text, page: state.page)
                .debounce(
                    id: ID.debounce,
                    for: 2.0,
                    scheduler: DispatchQueue.main
                )
                .cancellable(id: ID.debounce) // 동일한 debounce ID를 사용하여 중복 요청 방지
                .eraseToEffect() // Effect로 변환
        case .fetchRepositoriesResponse(let result):
            state.isLoading = false
            // 새로운 데이터를 기존 데이터에 추가
                if state.items == nil {
                    print("첫 번째 요청 시")
                    state.items = result.items // 첫 번째 요청 시
                } else {
                    print("추가된 데이터 합치기")
                    state.items?.append(contentsOf: result.items) // 추가된 데이터 합치기
                }
                state.totalCount = result.totalCount ?? 0
            state.showingError = false
            state.errorMessage = ""
            return .none
        case .fetchError(let error):
            state.isLoading = false
            state.repositories = SearchRepository(totalCount: 0, incompleteResults: false, items: [])
            state.showingError = true
            state.errorMessage = error.localizedDescription
            return .none
        case .itemTapped(let item):
            if let url = item.htmlURL { // 아이템에서 URL 가져오기
                if let url = URL(string: url) {
                    UIApplication.shared.open(url) // 웹 브라우저 열기
                }
            }
            return .none
        case .dismissError:
            return .none
        }
    }
}

