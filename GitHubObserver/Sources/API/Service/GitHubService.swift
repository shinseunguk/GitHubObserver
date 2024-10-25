//
//  GitHubService.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/23/24.
//

import Moya
import Foundation
import Combine
import ComposableArchitecture

class GitHubService {
//    private let provider = MoyaProvider<GitHubAPI>()
        private let provider = MoyaProvider<GitHubAPI>(plugins: [NetworkLoggerPlugin()]) // Debug
    
    /// Repository 검색 Func
    /// - Parameters:
    ///   - query: 검색어
    ///   - page: 페이지
    /// - Returns: Repository Set Func 호출
    func searchRepositories(query: String, page: Int) -> Effect<RepositorySearchFeature.Action> {
        return Effect.run { subscriber in
            let cancellable = self.provider.request(.searchRepositories(query: query, page: page)) { result in
                switch result {
                case let .success(response):
                    do {
                        // 상태 코드가 성공 범위인지 확인 (예: 200~299)
                        guard (200...299).contains(response.statusCode) else {
                            throw GitHubError.invalidStatusCode(response.statusCode)
                        }
                        
                        // JSON 디코딩 (응답을 적절한 모델로 변환)
                        let repositories = try JSONDecoder().decode(SearchRepository.self, from: response.data)
                        subscriber.send(.fetchRepositoriesResponse(result: repositories))
                        subscriber.send(completion: .finished)
                    } catch let decodingError as DecodingError {
                        print(decodingError)
                        // JSON 디코딩 오류 처리
                        subscriber.send(.fetchError(error: .parsingError(decodingError)))
                        subscriber.send(completion: .finished)
                    } catch {
                        // 기타 오류 처리
                        subscriber.send(.fetchError(error: .unknownError(error)))
                        subscriber.send(completion: .finished)
                    }
                case let .failure(error):
                    // 네트워크 오류 처리
                    subscriber.send(.fetchError(error: .networkError(error)))
                    subscriber.send(completion: .finished)
                }
            }
            
            return AnyCancellable {
                cancellable.cancel()
            }
        }
    }
    
    
    /// GitHub AccessToken Request Func
    /// - Parameter code: OAuth return값인 code
    /// - Returns: requestMyInfo Func 호출
    func requestAccessToken(code: String) -> Effect<ProfileFeature.Action> {
        return Effect.run { subscriber in
            let cancellable = self.provider.request(.accessToken(code: code)) { result in
                switch result {
                case let .success(response):
                    let responseString = String(data: response.data, encoding: .utf8) ?? ""
                    
                    guard let token = extractAccessToken(from: responseString) else {
                        subscriber.send(completion: .finished)
                        return
                    }
                    
                    subscriber.send(.requestMyInfo(token: token))
                    subscriber.send(completion: .finished)
                case let .failure(error):
                    subscriber.send(.fetchError(error: .networkError(error)))
                    subscriber.send(completion: .finished)
                }
            }
            
            return AnyCancellable {
                cancellable.cancel()
            }
        }
    }
    
    /// GitHub 내 정보 Request Func
    /// - Parameter token: requestAccessToken의 Response값인 token
    /// - Returns: MyInfo Set Action
    func requestMyInfo(token: String) -> Effect<ProfileFeature.Action> {
        return Effect.run { subscriber in
            let cancellable = self.provider.request(.myInfo(token: token)) { result in
                switch result {
                case let .success(response):
                    do {
                        let owner = try JSONDecoder().decode(Owner.self, from: response.data)
                        subscriber.send(.responseMyInfo(owner: owner))
                        subscriber.send(completion: .finished)
                    } catch let decodingError as DecodingError {
                        subscriber.send(.fetchError(error: .parsingError(decodingError)))
                        subscriber.send(completion: .finished)
                    } catch {
                        subscriber.send(.fetchError(error: .unknownError(error)))
                        subscriber.send(completion: .finished)
                    }
                case let .failure(error):
                    subscriber.send(.fetchError(error: .networkError(error)))
                    subscriber.send(completion: .finished)
                }
            }
            
            return AnyCancellable {
                cancellable.cancel()
            }
        }
    }
    
    /// GitHub 내 Repostiory Request Func
    /// - Returns: Repository Set Func
    func requestMyRepository(ownerId: String) -> Effect<ProfileFeature.Action> {
        return Effect.run { subscriber in
            let cancellable = self.provider.request(.myRepos(ownerId: ownerId)) { result in
                switch result {
                case let .success(response):
                    do {
                        guard (200...299).contains(response.statusCode) else {
                            throw GitHubError.invalidStatusCode(response.statusCode)
                        }
                        
                        let item = try JSONDecoder().decode([Item].self, from: response.data)
                        subscriber.send(.responseRepos(item: item))
                        subscriber.send(completion: .finished)
                    } catch let decodingError as DecodingError {
                        subscriber.send(.fetchError(error: .parsingError(decodingError)))
                        subscriber.send(completion: .finished)
                    } catch {
                        print("error => \(error)")
                        subscriber.send(.fetchError(error: .unknownError(error)))
                        subscriber.send(completion: .finished)
                    }
                case let .failure(error):
                    subscriber.send(.fetchError(error: .networkError(error)))
                    subscriber.send(completion: .finished)
                }
            }
            
            return AnyCancellable {
                cancellable.cancel()
            }
        }
    }
}
