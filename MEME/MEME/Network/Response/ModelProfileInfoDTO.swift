//
//  ModelProfileInfoDTO.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation

struct ModelProfileInfoResponse: Codable {
    let result: String
    let message: String
    let data: ModelProfileInfoData?
    let code: Int
}
    
struct ModelProfileInfoData: Codable {
    let userId: Int
    let profileImg: String
    let nickname: String
    let gender: Gender
    let skinType: SkinType
    let personalColor: PersonalColor
}
