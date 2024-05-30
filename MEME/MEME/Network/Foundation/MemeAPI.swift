//
//  MemeAPI.swift
//  MEME
//
//  Created by 이동현 on 1/30/24.
//

import Foundation
import Moya

// MARK: - MEME Domain
enum MemeDomain {
    case register
    case mypage
    case search
    case profile
    case reservation
    case portfolio
    case review
    case recommend
    case auth
    case availabletime
}

extension MemeDomain {
    var url: String {
        switch self {
        case .register:
            return "/register"
        case .mypage:
            return "/mypage"
        case .search:
            return "/search"
        case .profile:
            return "/profile"
        case .reservation:
            return "/reservation"
        case .portfolio:
            return "/portfolio"
        case .review:
            return "/review"
        case .recommend:
            return "/recommend"
        case .auth:
            return ""
        case .availabletime:
            return ""
        }
    }
}

/// API가 기본적으로 준수해야 하는 정보
///
/// domain : Domain(ex. auth, mypage 등)
/// urlPath : Domain 뒤에 붙는 상세 경로(path)
/// error : 상태코드에 따른 NetworkError 구분하는데 사용되는 딕셔너리
protocol MemeAPI: TargetType {
    var domain: MemeDomain { get }
    var urlPath: String { get }
    var error: [Int: NetworkError]? { get }
    var headerType: HTTPHeaderFields { get }
}

extension MemeAPI {
    var baseURL: URL {
        return URL(string: SecretInfoManager.baseURL)!
    }
    
    var path: String {
        return domain.url + urlPath
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var headers: [String: String]? {
        switch headerType {
        case .plain:
            return [
                HTTPHeaderFieldsKey.contentType: HTTPHeaderFieldsValue.json
            ]
        case .html:
            return [
                HTTPHeaderFieldsKey.contentType: HTTPHeaderFieldsValue.html
            ]
        case .hasAccessToken:
            return [
                HTTPHeaderFieldsKey.contentType: HTTPHeaderFieldsValue.json,
                HTTPHeaderFieldsKey.authorization: "Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtZW1lX3VtYyIsImlhdCI6MTcwNzk4NTkwOSwiZXhwIjoxNzEwNTc3OTA5LCJzdWIiOiJhY2Nlc3MtdG9rZW4iLCJ1c2VybmFtZSI6IuyehOyerOyYgSIsInJvbGUiOiJST0xFX01PREVMIn0.8MSYAcPOl6IfxOARHAS_aiYhG6JaQ1NjkuKqt_mZJEKgRLOxHkxHqbzZ2fmoq4Il1EVj3ieOU6Uq2WHFPcPZ6g"
            ]
        }
    }
}
