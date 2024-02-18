//
//  Gender.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation


enum Gender: String, Codable, CaseIterable {
    case MALE
    case FEMALE
    
    var korString: String {
        switch self {
        case .MALE:
            "남성"
        case .FEMALE:
            "여성"
        }
    }
    static func rawValueFrom(displayText: String) -> String {
        switch displayText {
        case "남성":
            return Gender.MALE.rawValue
        case "여성":
            return Gender.FEMALE.rawValue
        default:
            return ""
        }
    }
}
