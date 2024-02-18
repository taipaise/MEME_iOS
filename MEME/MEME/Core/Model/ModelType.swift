//
//  ModelType.swift
//  MEME
//
//  Created by 임아영 on 2/15/24.
//

import Foundation

enum SkinType: String, Codable {
    case dry = "DRY"
    case common = "COMMON"
    case oily = "OILY"
    case combinational = "COMBINATIONAL"
    
    var displayText: String {
        switch self {
        case .dry:
            return "건성"
        case .common:
            return "중성"
        case .oily:
            return "지성"
        case .combinational:
            return "복합성"
        }
    }
    static func rawValueFrom(displayText: String) -> String {
        switch displayText {
        case "건성":
            return SkinType.dry.rawValue
        case "중성":
            return SkinType.common.rawValue
        case "지성":
            return SkinType.oily.rawValue
        case "복합성":
            return SkinType.combinational.rawValue
        default:
            return ""
        }
    }
}


enum PersonalColor: String, Codable {
    case spring = "SPRING"
    case summer = "SUMMER"
    case autumn = "AUTUMN"
    case winter = "WINTER"
    
    var displayText: String {
        switch self {
        case .spring:
            return "봄웜톤"
        case .summer:
            return "여름쿨톤"
        case .autumn:
            return "가을웜톤"
        case .winter:
            return "겨울쿨톤"
        }
    }
    
    static func rawValueFrom(displayText: String) -> String {
        switch displayText {
        case "봄웜톤":
            return PersonalColor.spring.rawValue
        case "여름쿨톤":
            return PersonalColor.summer.rawValue
        case "가을웜톤":
            return PersonalColor.autumn.rawValue
        case "겨울쿨톤":
            return PersonalColor.winter.rawValue
        default:
            return ""
        }
    }
}
