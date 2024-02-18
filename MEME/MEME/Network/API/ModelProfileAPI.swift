//
//  ProfileAPI.swift
//  MEME
//
//  Created by 임아영 on 2/13/24.
//

import Foundation
import Moya

enum ModelProfileAPI {
    case patchProfile(userId: Int, profileImg: String?, nickname: String?, gender: String?, skinType: String?, personalColor: String?)
}

extension ModelProfileAPI: MemeAPI {
    var domain: MemeDomain {
        return .mypage
    }
    
    var urlPath: String {
        switch self {
        case .patchProfile:
            return "/profile/model"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .patchProfile:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchProfile:
            return .patch
        }
    }

    var task: Task {
        switch self {
        case .patchProfile(let userId, let profileImg, let nickname, let gender, let skinType, let personalColor):
            var parameters: [String: Any] = ["userId": userId]
            if let profileImg = profileImg { parameters["profileImg"] = profileImg }
            if let nickname = nickname { parameters["nickname"] = nickname }
            if let gender = gender { parameters["gender"] = gender }
            if let skinType = skinType { parameters["skinType"] = skinType }
            if let personalColor = personalColor { parameters["personalColor"] = personalColor }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)

        }
    }
}
