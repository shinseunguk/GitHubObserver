//
//  ProfileView.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/11/24.
//

import SwiftUI
import ComposableArchitecture

enum ProfileViewConstants {
    static let needLogin = "Login is required.".localized()
    static let login = "Login".localized()
    static let cancel = "Cancel".localized()
}

public struct ProfileView: View {
    
    let store: StoreOf<ProfileFeature>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.top, 50)
                Text(ProfileViewConstants.needLogin)
                    .padding(.top, 15)
                    .fontWeight(.bold)
                Spacer()
            }
            .alert(isPresented: viewStore.binding(
                get: \.showingAlert,
                send: .setAlertDismissed
            ), content: {
                Alert(
                    title: Text(ProfileViewConstants.needLogin),
                    primaryButton: .default(Text("Login"), action: {
                        viewStore.send(.goToGitHubPage) // primaryButton 눌렀을 때만 send 호출
                    }),
                    secondaryButton: .cancel(Text("Cancel"))
                )
            })
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    ProfileView(store: Store(
        initialState: ProfileFeature.State(),
        reducer: ProfileFeature()
    ))
}

