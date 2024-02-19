//
//  SkinType.swift
//  MEME
//
//  Created by 이동현 on 2/15/24.
//

import Foundation

enum SkinType: String, Codable, CaseIterable {
    case DRY, COMMON, OILY, COMBINATIONAL, UNKNOWN
    
    var korString: String {
        switch self {
        case .DRY:
            return "건성"
        case .COMMON:
            return "중성"
        case .OILY:
            return "지성"
        case .COMBINATIONAL:
            return "복합성"
        case .UNKNOWN:
            return "모르겠음"
        }
    }
    
    static func rawValueFrom(displayText: String) -> String {
        switch displayText {
        case "건성":
            return SkinType.DRY.rawValue
        case "중성":
            return SkinType.COMMON.rawValue
        case "지성":
            return SkinType.OILY.rawValue
        case "복합성":
            return SkinType.COMBINATIONAL.rawValue
        default:
            return ""
        }
    }
}


