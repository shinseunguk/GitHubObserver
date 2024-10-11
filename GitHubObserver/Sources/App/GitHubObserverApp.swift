import SwiftUI

@main
struct GitHubObserverApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    print(".onOpenURL\n\(url)")
                })
        }
    }
}
