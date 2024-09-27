//
//  GitHubError.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/27/24.
//

import Moya

enum GitHubErrorConstants {
    static let networkError = "Network connection failed.".localized() // 네트워크 오류
    static let parsingError = "Failed to parse response data.".localized() // 파싱 오류
    static let invalidStatusCode = "Invalid response from server.".localized() // 잘못된 상태 코드
    static let unknownError = "An unknown error occurred.".localized() // 알 수 없는 오류
}

// GitHubError 정의
enum GitHubError: Error {
    case networkError(MoyaError)          // 네트워크 오류
    case parsingError(DecodingError)      // JSON 파싱 오류
    case invalidStatusCode(Int)           // 유효하지 않은 HTTP 상태 코드
    case unknownError(Error)              // 기타 알 수 없는 오류
    
    // 사용자에게 표시될 로컬라이즈된 에러 메시지
    var localizedDescription: String {
        switch self {
        case .networkError(let moyaError):
            // 네트워크 오류에 대한 메시지와 구체적인 에러 설명을 포함
            return GitHubErrorConstants.networkError + " \(moyaError.localizedDescription)"
            
        case .parsingError:
            // JSON 파싱 오류 메시지
            return GitHubErrorConstants.parsingError
            
        case .invalidStatusCode(let statusCode):
            // 잘못된 상태 코드에 대한 메시지와 상태 코드를 포함
            return "\(GitHubErrorConstants.invalidStatusCode) (Status code: \(statusCode))"
            
        case .unknownError(let error):
            // 알 수 없는 오류에 대한 메시지와 구체적인 에러 설명을 포함
            return GitHubErrorConstants.unknownError
        }
    }
}
