//
//  LogOutAPI.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

enum LogOutAPI {
    case logOut
}

extension LogOutAPI: MemeAuthAPI {
    var domain: MemeAuthDomain {
        return .auth
    }

    var urlPath: String {
        switch self {
        case .logOut:
            return ""
        }
    }
    
    var error: [Int : NetworkError]? {
        return nil
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .logOut:
            return .plain
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logOut:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .logOut:
            return .requestPlain
        }
    }
}
