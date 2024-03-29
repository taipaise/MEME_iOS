//
//  AuthAPI.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

enum SocialProvider: String {
    case APPLE
    case KAKAO
}

enum AuthAPI {
    case login(idToken: String, provider: SocialProvider)
    case logout
    case withdraw
    case modelSignUp(
        idToken: String,
        provider: String,
        profileImg: String,
        username: String,
        nickname: String,
        gender: String,
        skinType: String,
        personalColor: String
    )

    case artistSignUp(
        idToken: String,
        provider: String,
        profileImg: String,
        username: String,
        nickname: String
    )
    
    case artistProfile(
        userId: Int,
        profileImg: String,
        nickName: String,
        gender: Gender,
        introduction: String,
        workExperience: String,
        region: [String],
        specialization: [String],
        makeupLocation: String,
        shopLocation: String,
        week: [String],
        selectedTime: [String]
    )
    case reissue(accessToken: String, refreshToken: String)
}

extension AuthAPI: MemeAuthAPI {
    var domain: MemeAuthDomain {
        return .auth
    }

    var urlPath: String {
        switch self {
        case .login:
            return "/check"
        case .logout:
            return "/auth/logout"
        case .withdraw:
            return "/auth/withdraw"
        case .modelSignUp:
            return "/signup/model"
        case .artistSignUp:
            return "/signup/artist"
        case .artistProfile:
            return "/auth/artist/extra"
        case .reissue:
            return "/reissue"
        }
    }
    
    var error: [Int : NetworkError]? {
        return nil
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .login, .modelSignUp, .artistSignUp, .reissue:
            return .plain
        case .logout, .withdraw, .artistProfile:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
            
        case .login(idToken: let idToken, provider: let provider):
            let parameters: [String: Any] = [
                "id_token": idToken,
                "provider": provider.rawValue
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .logout:
            return .requestPlain
            
        case .withdraw:
            return .requestPlain
            
        case .modelSignUp(
            idToken: let idToken,
            provider: let provider,
            profileImg: let profileImg,
            username: let username,
            nickname: let nickname,
            gender: let gender,
            skinType: let skinType,
            personalColor: let personalColor
        ):

            let parameters: [String: Any] = [
                "id_token": idToken,
                "provider": provider,
                "profile_img": profileImg,
                "username": username,
                "nickname": nickname,
                "gender": gender,
                "skin_type": skinType,
                "personal_color": personalColor
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .artistSignUp(
            idToken: let idToken,
            provider: let provider,
            profileImg: let profileImg,
            username: let username,
            nickname: let nickname
        ):
            let parameters: [String: Any] = [
                "id_token": idToken,
                "provider": provider,
                "profileImg": profileImg,
                "username": username,
                "nickname": nickname
            ]
            print("@!#!@#!@#!@#!@!@#!")
            print(parameters)
            print("@!#!@#!@#!@#!@!@#!")
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .artistProfile(
            userId: let userId,
            profileImg: let profileImg,
            nickName: let nickName,
            gender: let gender,
            introduction: let introduction,
            workExperience: let workExperience,
            region: let region,
            specialization: let specialization,
            makeupLocation: let makeupLocation,
            shopLocation: let shopLocation,
            week: let week,
            selectedTime: let selectedTime
        ):
            
            let jsonString = """
            {
              "userId": \(userId),
              "profileImg": \(profileImg),
              "nickname": \(nickName),
              "gender": \(gender.rawValue),
              "introduction": \(introduction),
              "workExperience": \(workExperience),
              "region": [
                "JONGNO"
              ],
              "specialization": [
                \(specialization)
              ],
              "makeupLocation": "\(makeupLocation)",
              "shopLocation": "\(shopLocation)",
              "availableDayOfWeekAndTime": {
                "MON": ["_00_00", "_00_30"]
              }
            }
            """
    
            return .requestJSONEncodable(jsonString)
            
        case .reissue(accessToken: let accessToken, refreshToken: let refreshToken):
            let parameters: [String: Any] = [
                "accessToken": accessToken,
                "refreshToken": refreshToken
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}

struct AvailableTime: Codable {
    let day: String
    let time: String
}
