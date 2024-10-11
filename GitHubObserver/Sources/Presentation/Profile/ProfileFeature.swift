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
    
    let loginManager = LoginManager.shared
    
    struct State: Equatable {
        var login: Bool = false
        var showingAlert: Bool = false
    }
    
    enum Action {
        case onAppear
        case setAlertDismissed
        case goToGitHubPage
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.showingAlert = true
            return .none
        case .setAlertDismissed:
            state.showingAlert = false
            return .none
        case .goToGitHubPage:
            print("goToGitHubPage")
            loginManager.requestCode()
            
            return .none
        }
    }
}

