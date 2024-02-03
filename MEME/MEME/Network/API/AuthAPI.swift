//
//  AuthAPI.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

enum AuthAPI {
    case kakakoLogin
}

extension AuthAPI: MemeAPI {
    var domain: MemeDomain {
        return .auth
    }
    
    var urlPath: String {
        switch self {
        case .kakakoLogin:
            return "/kakao"
        }
    }
    
    var error: [Int : NetworkError]? {
        return nil
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .kakakoLogin:
            return .plain
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakakoLogin:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakakoLogin:
            return .requestPlain
        }
    }
}
