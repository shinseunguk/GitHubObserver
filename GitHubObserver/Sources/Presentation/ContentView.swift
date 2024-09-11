import SwiftUI
import Foundation

enum ContentViewConstants {
    static let RepositorySearch = "Repository Search".localized()
    
    static let Profile = "Profile".localized()
}

public struct ContentView: View {
    
    let constants = ContentViewConstants.self
    
    public init() {}

    public var body: some View {
        TabView {
          RepositorySearchView()
            .tabItem {
              Image(systemName: "magnifyingglass")
              Text(constants.RepositorySearch)
            }
          ProfileView()
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
