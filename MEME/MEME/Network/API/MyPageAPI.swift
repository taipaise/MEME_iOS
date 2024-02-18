//
//  MyPageAPI.swift
//  MEME
//
//  Created by 임아영 on 2/9/24.

//

import Foundation
import Moya

enum MyPageAPI {
    case getMyPageProfile(userId: Int)
}

extension MyPageAPI: MemeAPI {
    var domain: MemeDomain {
        return .mypage
    }
    
  var urlPath: String {
        switch self {
        case .getMyPageProfile(let userId):
            return "/profile/\(userId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return nil 
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getMyPageProfile:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyPageProfile:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getMyPageProfile:
            return .requestPlain
        }
    }
}
