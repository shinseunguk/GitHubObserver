import SwiftUI
import ComposableArchitecture

@main
struct GitHubObserverApp: App {
    
    let store: StoreOf<ProfileFeature> = Store(initialState: ProfileFeature.State()) { ProfileFeature()._printChanges() }
        
    var body: some Scene {
        WindowGroup {
            MainView(store: self.store)
                .onOpenURL(perform: { url in
                    store.send(.openURLReceived(url)) // URL에 따라 액션 전달
                })
        }
    }
}
