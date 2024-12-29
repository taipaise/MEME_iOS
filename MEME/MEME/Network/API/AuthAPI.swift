//
//  AuthAPI.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

enum AuthAPI {
    case validateUser(idToken: String, provider: SocialProvider)
    case validateNickname(nickname: String)
    case reissue(accessToken: String, refreshToken: String)
    case logout
    case leave
    case socialSingUp(
        idToken: String,
        provider: SocialProvider,
        role: RoleType,
        username: String,
        nickname: String,
        profileImg: String
    )
}

extension AuthAPI: MemeAPI {
    var domain: MemeDomain {
        return .auth
    }
    
    var urlPath: String {
        switch self {
        case .validateUser:
            return "/validate/user"
        case .validateNickname:
            return "/validate/nickname"
        case .reissue:
            return "/reissue"
        case .logout:
            return "/logout"
        case .leave:
            return "/leave"
        case .socialSingUp:
            return "/join/social"
        }
    }
    
    var error: [Int : NetworkError]? {
        return nil
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .validateUser, .validateNickname, .reissue, .socialSingUp:
            return .plain
        case .logout, .leave:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .validateUser(idToken: let idToken, provider: let provider):
            let parameters: [String: Any] = [
                "idToken": idToken,
                "provider": provider.rawValue
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .validateNickname(nickname: let nickname):
            let parameters: [String: Any] = [
                "nickname": nickname
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .logout, .leave:
            return .requestPlain
            
        case .socialSingUp(
            idToken: let idToken,
            provider: let provider,
            role: let role,
            username: let username,
            nickname: let nickname,
            profileImg: let profileImg
        ):
            let parameters: [String: Any] = [
                "idToken": idToken,
                "provider": provider.rawValue,
                "role": role.rawValue,
                "username": username,
                "nickname": nickname,
                "profileImg": profileImg
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .reissue(accessToken: let accessToken, refreshToken: let refreshToken):
            let parameters: [String: Any] = [
                "accessToken": accessToken,
                "refreshToken": refreshToken
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
