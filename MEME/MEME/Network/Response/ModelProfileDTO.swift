//
//  ProfileDTO.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation

struct ModelProfileResponse: Codable {
    let userId: Int
    let profileImg: String
    let nickname: String
    let gender: String
    let skinType: String
    let personalColor: String
}

struct ModelProfileDTO: Codable {
    let result: String
    let message: String
    let data: ModelProfileResponse?
    let code: Int

    enum CodingKeys: String, CodingKey {
        case result, message, data
        case code = "code"
    }
}


//struct ModelProfileRequest: Codable {
//    let userId: Int
//    let profileImg: String
//    let nickname: String
//    let gender: Gender
//    let skinType: SkinType
//    let personalColor: PersonalColor
//}
//
//struct ModelProfileData: Codable {
//    let userId: Int
//    let profileImg: String
//    let nickname: String
//    let gender: Gender
//    let skinType: SkinType
//    let personalColor: PersonalColor
//}
//
//struct ModelProfileResponse: Codable {
//    let result: String
//    let message: String
//    let data: ModelProfileData?
//    let code: Int
//
//    enum CodingKeys: String, CodingKey {
//        case result, message, data
//        case code = "code"
//    }
//}

//
//// MARK: - ModelProfileResponse
//
//struct ModelProfileResponse: Codable {
//    let result: String
//    let message: String
//    let data: String?
//    let status: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case result, message, data
//        case status = "code"
//    }
//}
