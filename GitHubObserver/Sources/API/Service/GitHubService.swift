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
    private let provider = MoyaProvider<GitHubAPI>()/*(plugins: [NetworkLoggerPlugin()])*/

    func searchRepositories(query: String, page: Int) -> Effect<RepositorySearchFeature.Action> {
        return Effect.future { promise in
            self.provider.request(.searchRepositories(query: query, page: page)) { result in
                switch result {
                case let .success(response):
                    do {
                        // 상태 코드가 성공 범위인지 확인 (예: 200~299)
                        guard (200...299).contains(response.statusCode) else {
                            throw GitHubError.invalidStatusCode(response.statusCode)
                        }
                        
                        // JSON 디코딩 (응답을 적절한 모델로 변환)
                        let repositories = try JSONDecoder().decode(SearchRepository.self, from: response.data)
                        promise(.success(.fetchRepositoriesResponse(result: repositories)))
                    } catch let decodingError as DecodingError {
                        // JSON 디코딩 오류 처리
                        promise(.success(.fetchError(error: .parsingError(decodingError))))
                    } catch {
                        // 기타 오류 처리
                        promise(.success(.fetchError(error: .unknownError(error))))
                    }
                case let .failure(error):
                    // 네트워크 오류 처리
                    promise(.success(.fetchError(error: .networkError(error))))
                }
            }
        }
    }
}
