//
//  RepositoryListView.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/24/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct RepositoryListView: View {
    
    var avatarURL: URL
    var repositoryName: String
    var repostioryDescription: String
    var language: String
    var stargazersCount: Int
    
    init(avatarURL: String, repositoryName: String, repostioryDescription: String, language: String, stargazersCount: Int) {
        self.avatarURL = URL(string: avatarURL)!
        self.repositoryName = repositoryName
        self.repostioryDescription = repostioryDescription
        self.language = language
        self.stargazersCount = stargazersCount
    }
    
    var body: some View {
        HStack {
            KFImage(avatarURL)
                .placeholder {
                    Image(systemName: "")
                }.retry(maxCount: 3, interval: .seconds(5))
                .resizable()
                  .frame(width: 50, height: 50) //resize
                  .cornerRadius(20) //둥근 코너 설정
                  .shadow(radius: 5) // 그림자 설정
                  .padding(.trailing, 20)
            
            VStack(alignment: .leading, spacing: 5.0) {
                Text(repositoryName)
                    .font(.headline)
                Text(repostioryDescription)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                HStack(spacing: 6) {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Color.init(hex: hexColor(for: language)))
                    Text(language)
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                        .padding(.trailing, 20)
                    
                    Image(systemName: "star")
                        .frame(width: 10, height: 10)
                        .padding(.trailing, 3)
                    Text(String(stargazersCount))
                        .font(.system(size: 15))
                        .fontWeight(.medium)
                }
            }
        }
    }
}


#Preview {
    RepositoryListView(
        avatarURL: "https://avatars.githubusercontent.com/u/6407041?v=4",
        repositoryName: "RxSwift",
        repostioryDescription: "Reactive Programming in Swift",
        language: "Swift",
        stargazersCount: 299
    )
}
