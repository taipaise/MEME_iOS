//
//  MemeAPIAuth.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//
import Foundation
import Moya

// MARK: - MEME Domain
enum MemeAuthDomain {
    case auth
    case logout
    case withdraw
}

extension MemeAuthDomain {
    var url: String {
        switch self {
        case .auth:
            return ""
        case .logout:
            return "/logout"
        case .withdraw:
            return "/withdraw"
        }
    }
}

/// API가 기본적으로 준수해야 하는 정보
///
/// domain : Domain(ex. auth, mypage 등)
/// urlPath : Domain 뒤에 붙는 상세 경로(path)
/// error : 상태코드에 따른 NetworkError 구분하는데 사용되는 딕셔너리
protocol MemeAuthAPI: TargetType {
    var domain: MemeAuthDomain { get }
    var urlPath: String { get }
    var error: [Int: NetworkError]? { get }
    var headerType: HTTPHeaderFields { get }
}

extension MemeAuthAPI {
    var baseURL: URL {
        return URL(string: SecretInfoManager.baseURLAuth)!
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
                HTTPHeaderFieldsKey.authorization: "Bearer Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJtZW1lX3VtYyIsImlhdCI6MTcwNzA5NTAwMSwiZXhwIjoxNzA3MDk2ODAxLCJzdWIiOiJhY2Nlc3MtdG9rZW4iLCJ1c2VybmFtZSI6IuyehOyerOyYgSIsInJvbGUiOiJST0xFX01PREVMIn0.r5N80Cn1Y1LeUEtPsKyhp-oVv5akK09oaErtgwBavR_jEnNJkpOKJtFdmKOf2ewyxR655qIZZ7D1yAaJNZxELg"
            ]
        }
    }
}
