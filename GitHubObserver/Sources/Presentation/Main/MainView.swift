import SwiftUI
import Foundation
import ComposableArchitecture

enum ContentViewConstants {
    static let RepositorySearch = "Repository Search".localized()
    static let Profile = "Profile".localized()

    static let loginAlertTitle = "Login is required".localized()
    static let logoutAlertTitle = "Do you want to logout?".localized()
    static let cancel = "Cancel".localized()
    
    static let Login = "Login".localized()
    static let Logout = "Logout".localized()
}

public struct MainView: View {

    let constants = ContentViewConstants.self
    let profileStore: StoreOf<ProfileFeature>
    
    init(store: StoreOf<ProfileFeature>) {
        self.profileStore = store
        
        // TabBar Appearance 설정
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground() // 불투명 배경
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance // iOS 13 이상
    }

    public var body: some View {
        WithViewStore(profileStore, observe: { $0 }) { viewStore in
            TabView {
                NavigationView {
                    RepositorySearchView(
                        store: Store(initialState: RepositorySearchFeature.State()) {
                            RepositorySearchFeature()._printChanges()
                        }
                    )
                    .navigationTitle(constants.RepositorySearch)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button(
                            viewStore.state.owner == nil ? constants.Login : constants.Logout
                        ) {
                            viewStore.send(viewStore.state.owner == nil ? .goToGitHubPage : .setShowingAlert)
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(constants.RepositorySearch)
                }
                
                NavigationView {
                    ProfileView(store: profileStore)
                    .navigationTitle(constants.Profile)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button(
                            viewStore.state.owner == nil ? constants.Login : constants.Logout
                        ) {
                            viewStore.send(.setShowingAlert)
                        }
                    }
                }
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text(constants.Profile)
                }
            }
            .alert(isPresented: viewStore.binding(
                get: \.showingAlert,
                send: .setAlertDismissed
            ), content: {
                Alert(
                    title: Text(
                        viewStore.state.owner == nil ? constants.loginAlertTitle : constants.logoutAlertTitle
                    ),
                    primaryButton: .default(
                        Text(
                            viewStore.state.owner == nil ? constants.Login : constants.Logout
                            ), action: {
                        viewStore.send(viewStore.state.owner == nil ? .goToGitHubPage : .logout)
                    }),
                    secondaryButton: .cancel(Text(constants.cancel))
                )
            })
            .font(.headline)
            .onAppear {
                viewStore.send(.checkLogin)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store: Store(initialState: ProfileFeature.State()) { ProfileFeature()._printChanges() }
        )
    }
}
