//
//  PersonalColor.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation

enum PersonalColor: String, Codable,CaseIterable {
    case SPRING, SUMMER, AUTUMN, WINTER, UNKNOWN
    
    var korString: String {
        switch self {
        case .SPRING:
            "봄웜톤"
        case .SUMMER:
            "여름쿨톤"
        case .AUTUMN:
            "가을웜톤"
        case .WINTER:
            "겨울쿨톤"
        case .UNKNOWN:
            "모르겠음"
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
