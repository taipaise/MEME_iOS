//
//  ArtistType.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation

enum Category: String, Codable {
    case daily = "DAILY"
    case interview = "INTERVIEW"
    case actor = "ACTOR"
    case party = "PARTY"
    case wedding = "WEDDING"
    case prosthetic = "PROSTHETIC"
    case studio = "STUDIO"
    case etc = "ETC"
    
    static func rawValueFrom(displayText: String) -> String {
        switch displayText {
        case "데일리 메이크업":
            return Category.daily.rawValue
        case "배우 메이크업":
            return Category.actor.rawValue
        case "면접 메이크업":
            return Category.interview.rawValue
        case "파티/이벤트 메이크업":
            return Category.party.rawValue
        case "웨딩 메이크업":
            return Category.wedding.rawValue
        case "특수 메이크업":
            return Category.prosthetic.rawValue
        case "스튜디오 메이크업":
            return Category.studio.rawValue
        case "기타(속눈썹, 퍼스널컬러)":
            return Category.etc.rawValue
            
        default:
            return ""
        }
    }
}

enum MakeupLocation: String, Codable {
    case shop = "SHOP"
    case visit = "VISIT"
    case both = "BOTH"
    
    static func rawValueFrom(displayText: String) -> String {
        switch displayText {
        case "제가 다니는 샵에서 진행해요":
            return MakeupLocation.shop.rawValue
        case "직접 방문해서 진행해요":
            return MakeupLocation.visit.rawValue
        case "둘 다 상관없어요":
            return MakeupLocation.both.rawValue
        default:
            return ""
        }
    }
}

enum Times: String, Codable {
    case _04_00 = "04:00"
    case _04_30 = "04:30"
    case _05_00 = "05:00"
    case _05_30 = "05:30"
    case _06_00 = "06:00"
    case _06_30 = "06:30"
    case _07_00 = "07:00"
    case _07_30 = "07:30"
    case _08_00 = "08:00"
    case _08_30 = "08:30"
    case _09_00 = "09:00"
    case _09_30 = "09:30"
    case _10_00 = "10:00"
    case _10_30 = "10:30"
    case _11_00 = "11:00"
    case _11_30 = "11:30"
    case _12_00 = "12:00"
    case _12_30 = "12:30"
    case _13_00 = "13:00"
    case _13_30 = "13:30"
    case _14_00 = "14:00"
    case _14_30 = "14:30"
    case _15_00 = "15:00"
    case _15_30 = "15:30"
    case _16_00 = "16:00"
    case _16_30 = "16:30"
    case _17_00 = "17:00"
    case _17_30 = "17:30"
    case _18_00 = "18:00"
    case _18_30 = "18:30"
    case _19_00 = "19:00"
    case _19_30 = "19:30"
    case _20_00 = "20:00"
    case _20_30 = "20:30"
    case _21_00 = "21:00"
}
