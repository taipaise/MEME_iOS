//
//  PersonalColor.swift
//  MEME
//
//  Created by 정민지 on 2/19/24.
//

import Foundation

enum PersonalColor: String, Codable, CaseIterable {
    case SPRING
    case SUMMER
    case AUTUMN
    case WINTER
    case UNKNOWN

    var korString: String {
        switch self {
        case .SPRING:
            return "봄웜톤"
        case .SUMMER:
            return "여름쿨톤"
        case .AUTUMN:
            return "가을웜톤"
        case .WINTER:
            return "겨울쿨톤"
        case .UNKNOWN:
            return "모르겠음"
        }
    }

    static func rawValueFrom(displayText: String) -> String {
        switch displayText {
        case "봄웜톤":
            return PersonalColor.SPRING.rawValue
        case "여름쿨톤":
            return PersonalColor.SUMMER.rawValue
        case "가을웜톤":
            return PersonalColor.AUTUMN.rawValue
        case "겨울쿨톤":
            return PersonalColor.WINTER.rawValue
        default:
            return ""
        }
    }
    static func rawValueFrom(displayText: String) -> String {
        switch displayText {
        case "봄웜톤":
            return PersonalColor.SPRING.rawValue
        case "여름쿨톤":
            return PersonalColor.SUMMER.rawValue
        case "가을웜톤":
            return PersonalColor.AUTUMN.rawValue
        case "겨울쿨톤":
            return PersonalColor.WINTER.rawValue
        case "모르겠음":
            return PersonalColor.UNKNOWN.rawValue
        default:
            return ""
        }
    }
}
