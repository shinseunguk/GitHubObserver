import SwiftUI
import Foundation
import ComposableArchitecture

enum ContentViewConstants {
    static let RepositorySearch = "Repository Search".localized()
    static let Profile = "Profile".localized()
}

public struct ContentView: View {

    let constants = ContentViewConstants.self

    public init() {}

    public var body: some View {
        TabView {
            NavigationView {
                RepositorySearchView(store: Store(initialState: RepositorySearchFeature.State(), reducer: RepositorySearchFeature() ))
                    .navigationTitle(constants.RepositorySearch)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button("Login") {
                            print("Login")
                        }
                    }
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text(constants.RepositorySearch)
            }
            
            NavigationView {
                ProfileView(store: Store(
                    initialState: ProfileFeature.State(),
                    reducer: ProfileFeature()
                ))
                    .navigationTitle(constants.Profile)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        Button("Login") {
                            print("Login")
                        }
                    }
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text(constants.Profile)
            }
        }
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
