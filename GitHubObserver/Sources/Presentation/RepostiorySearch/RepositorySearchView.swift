//
//  RepositorySearchView.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/11/24.
//

import SwiftUI
import ComposableArchitecture
import KeyboardToolbar

let toolbarItems: [KeyboardToolbarItem] = [
    .dismissKeyboard
]

enum RepositorySearchViewConstants {
    static let Search = "Search".localized()
    static let Instructions = "Look up Repository".localized()
}

public struct RepositorySearchView: View {
    
    let store: StoreOf<RepositorySearchFeature>
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
                VStack {
                    Spacer()
                        .frame(height: 10)
                    HStack {
                        SearchBar(text: viewStore.binding(
                            get: \.text,
                            send: RepositorySearchFeature.Action.didChangeText
                        )) {
                            viewStore.send(.searchButtonTapped)
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                        
                        Button(action: {
                            viewStore.send(.searchButtonTapped)
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                                        
                                        .onAppear {
                                            if listIndex == items.count - 1 {
                                                viewStore.send(.scrollToBottom)
                                            }
                                        }
                                    }
                                }
                                .listStyle(PlainListStyle())
                                .scrollIndicators(.never) // 스크롤 인디케이터 숨김
                            }
                            
                            if viewStore.isLoading {
                                Color.black.opacity(0.05) // 터치 차단용 투명한 오버레이
                                    .ignoresSafeArea()
                                
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                            }
                        }
                    } else {
                        if viewStore.isLoading {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                            Spacer()
                        } else {
                            Spacer()
                            
                            Image(systemName: "doc.text.magnifyingglass")
                                .resizable()
                                .frame(width: 140, height: 170)
                                .foregroundColor(.blue)
                                .padding(.bottom, 20)
                            
                            Text(RepositorySearchViewConstants.Instructions)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Spacer()
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
            .keyboardToolbar(toolbarItems)
        }
    }
}

#Preview {
    RepositorySearchView(
        store: Store(initialState: RepositorySearchFeature.State()) {
            RepositorySearchFeature()._printChanges()
        }
    )
}
