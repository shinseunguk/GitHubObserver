//
//  RepositorySearchView.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/11/24.
//

import SwiftUI
import ComposableArchitecture

enum RepositorySearchViewConstants {
    static let Search = "Search".localized()
}

public struct RepositorySearchView: View {
    
    let store: StoreOf<RepositorySearchFeature>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    SearchBar(text: viewStore.binding(
                        get: \.text,
                        send: RepositorySearchFeature.Action.didChangeText
                    ))
                    
                    Button(action: {
                        viewStore.send(.searchButtonTapped)
                    }) {
                        Text(RepositorySearchViewConstants.Search)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(viewStore.isLoading || viewStore.text.isEmpty ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.trailing)
                    }
                    .disabled(viewStore.isLoading || viewStore.text.isEmpty)  // 텍스트가 비어있거나 로딩 중이면 버튼 비활성화
                }
                
                if let items = viewStore.items {
                    ZStack(alignment: .center) {
                        if viewStore.isLoading {
                            List(Array(items.enumerated()), id: \.element.id) { index, repository in
                                LazyVStack(alignment: .leading) {
                                    RepositoryListView(
                                        avatarURL: repository.owner.avatarURL ?? "",
                                        repositoryName: repository.name ?? "",
                                        repostioryDescription: repository.description ?? "",
                                        language: repository.language ?? "",
                                        stargazersCount: repository.stargazersCount ?? 0
                                    )
                                    .onTapGesture {
                                        // 아이템 클릭 이벤트 발생
                                        viewStore.send(.itemTapped(item: repository))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle()) // 버튼 스타일 설정
                                .onAppear {
                                    // 마지막 아이템이 나타났을 때 액션 실행
                                    if index == items.count - 1 {
                                        print("맨 밑 도달")
                                        viewStore.send(.scrollToBottom)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            
                            Color.black.opacity(0.05) // 터치 차단용 투명한 오버레이
                                .ignoresSafeArea()
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        } else {
                            List(Array(items.enumerated()), id: \.element.id) { index, repository in
                                LazyVStack(alignment: .leading) {
                                    RepositoryListView(
                                        avatarURL: repository.owner.avatarURL ?? "",
                                        repositoryName: repository.name ?? "",
                                        repostioryDescription: repository.description ?? "",
                                        language: repository.language ?? "",
                                        stargazersCount: repository.stargazersCount ?? 0
                                    )
                                    .onTapGesture {
                                        // 아이템 클릭 이벤트 발생
                                        viewStore.send(.itemTapped(item: repository))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle()) // 버튼 스타일 설정
                                .onAppear {
                                    // 마지막 아이템이 나타났을 때 액션 실행
                                    if index == items.count - 1 {
                                        print("맨 밑 도달")
                                        viewStore.send(.scrollToBottom)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                } else {
                    if viewStore.isLoading {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .red))
                        Spacer()
                    } else {
                        Rectangle()
                            .foregroundColor(.clear)
                    }
                }
            }
            .alert(
                isPresented: viewStore.binding(
                    get: \.showingError,
                    send: RepositorySearchFeature.Action.dismissError
                ),
                content: {
                    Alert(
                        title: Text(viewStore.errorMessage),
                        dismissButton: .default(Text("확인"))
                    )
                }
            )
        }
    }
}

#Preview {
    RepositorySearchView(store: Store(
        initialState: RepositorySearchFeature.State(),
        reducer: RepositorySearchFeature()
    ))
}
