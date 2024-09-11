import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        TabView {
          RepositorySearchView()
            .tabItem {
              Image(systemName: "magnifyingglass")
              Text("Repository Search")
            }
          ProfileView()
            .tabItem {
              Image(systemName: "person.crop.circle.fill")
              Text("Profile")
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
