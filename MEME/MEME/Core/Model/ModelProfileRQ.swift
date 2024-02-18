//
//  File.swift
//  MEME
//
//  Created by 임아영 on 2/15/24.
//

import Foundation

struct ModelProfileRequest: Codable {
    let model_id: Int64
    let profile_img: String
    let nickname: String
    let gender: Gender
    let skin_type: SkinType
    let personal_color: PersonalColor
}

enum Gender: String, Codable {
    case MALE
    case FEMALE
}

enum SkinType: String, Codable {
    case DRY
    case COMMON
    case OILY
    case COMBINATIONAL
}

enum PersonalColor: String, Codable {
    case SPRING
    case SUMMER
    case AUTUMN
    case WINTER
}
