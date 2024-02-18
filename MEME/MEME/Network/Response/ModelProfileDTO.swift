//
//  ProfileDTO.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation

struct ModelProfileRequest: Codable {
    let userId: Int
    let profileImg: String
    let nickname: String
    let gender: String
    let skinType: String
    let personalColor: String
}

struct ModelProfileResponse: Codable {
    let result: String
    let message: String
    let data: String?
    let statusCode: Int

    enum CodingKeys: String, CodingKey {
        case result, message, data
        case statusCode = "statusCode"
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
//    let statusCode: Int
//
//    enum CodingKeys: String, CodingKey {
//        case result, message, data
//        case statusCode = "statusCode"
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
//        case status = "statusCode"
//    }
//}
