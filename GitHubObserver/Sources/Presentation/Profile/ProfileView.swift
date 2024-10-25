//
//  ProfileView.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/11/24.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

enum ProfileViewConstants {
    static let needLogin = "Login is required".localized()
}

public struct ProfileView: View {
    
    let store: StoreOf<ProfileFeature>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                if viewStore.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                }
                
                VStack {
                    if let owner = viewStore.owner,
                       let avatarURLString = owner.avatarURL,
                       let avatarURL = URL(string: avatarURLString) {
                        KFImage(avatarURL)
                            .placeholder {
                                Image(systemName: "")
                            }.retry(maxCount: 3, interval: .seconds(5))
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle()) // 원형으로 클리핑
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2)) // 테두리 추가 (선택 사항)
                            .shadow(radius: 5) // 그림자 추가 (선택 사항)
                            .padding(.top, 20)
                        
                        if let name = owner.name,
                           let login = owner.login,
                           let bio = owner.bio {
                            VStack {
                                HStack {
                                    Text(name)
                                        .padding(.top, 15)
                                        .fontWeight(.bold)
                                    
                                    Text("/")
                                        .padding(.top, 15)
                                    
                                    Text(login)
                                        .padding(.top, 15)
                                        .fontWeight(.light)
                                }
                                
                                Text(bio)
                                    .padding(.top, 15)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                
                                if let items = viewStore.repostiory {
                                    Spacer()
                                        .frame(height: 20)
                                    ScrollView {
                                        LazyVStack(spacing: 10) {
                                            ForEach(Array(items.enumerated()), id: \.element.id) { listIndex, repository in
                                                RepositoryListView(
                                                    avatarURL: repository.owner.avatarURL ?? "",
                                                    repositoryName: repository.name ?? "",
                                                    repostioryDescription: repository.description ?? "",
                                                    language: repository.language ?? "",
                                                    stargazersCount: repository.stargazersCount ?? 0
                                                )
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.vertical, 10)
                                                .onTapGesture {
                                                    // 아이템 클릭 이벤트 발생
                                                    viewStore.send(.itemTapped(item: repository))
                                                }
                                                .buttonStyle(PlainButtonStyle()) // 버튼 스타일 설정
                                                
                                                Divider()
                                                    .padding(.leading, 20)
                                                    .frame(maxWidth: .infinity)
                                            }
                                        }
                                    }
                                } else {
                                    Spacer()
                                }
                            }
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.top, 20)
                        Text(ProfileViewConstants.needLogin)
                            .padding(.top, 15)
                            .fontWeight(.bold)
                        Spacer()
                    }
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
}

#Preview {
    ProfileView(
        store: Store(initialState: ProfileFeature.State()) {
            ProfileFeature()._printChanges()
        }
    )
}

