//
//  ModelProfileInfoAPI.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation

import Moya

enum ModelProfileInfoAPI {
    case getModelProfileInfo(userId: Int)
}

extension ModelProfileInfoAPI: MemeAPI {
    var domain: MemeDomain {
        return .mypage
    }
    
    var urlPath: String {
        switch self {
        case .getModelProfileInfo(let userId):
            return "/profile/model/\(userId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getModelProfileInfo:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getModelProfileInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getModelProfileInfo:
            return .requestPlain
        }
    }
}
