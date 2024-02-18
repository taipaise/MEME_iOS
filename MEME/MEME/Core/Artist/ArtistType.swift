//
//  ArtistType.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation

enum Gender: String, Codable {
    case male = "MALE"
    case female = "FEMALE"
    
    var displayText: String {
        switch self {
        case .male:
            return "남성"
        case .female:
            return "여성"
        }
    }
    static func rawValueFrom(displayText: String) -> String {
            switch displayText {
            case "남성":
                return Gender.male.rawValue
            case "여성":
                return Gender.female.rawValue
            default:
                return ""
            }
        }
}

enum WorkExperience: String, Codable {
    case one = "ONE"
    case two = "TWO"
    case three = "THREE"
    case four = "FOUR"
    case five = "FIVE"
    case six = "SIX"
    case seven = "SEVEN"
    case eight = "EIGHT"
    case nine = "NINE"
    case ten = "TEN"
}

enum Region: String, Codable {
    case jongno = "JONGNO"
    case jung = "JUNG"
    case yongsan = "YONGSAN"
    case seongdong = "SEONGDONG"
    case gwangjin = "GWANGJIN"
    case dongdaemun = "DONGDAEMUN"
    case jungnang = "JUNGNANG"
    case seongbuk = "SEONGBUK"
    case gangbu = "GANGBU"
    case dobong = "DOBONG"
    case nowon = "NOWON"
    case eunpyeong = "EUNPYEONG"
    case seodaemun = "SEODAEMUN"
    case mapo = "MAPO"
    case yangcheon = "YANGCHEON"
    case gangseo = "GANGSEO"
    case guro = "GURO"
    case geumcheon = "GEUMCHEON"
    case yeongdeungp = "YEONGDEUNGP"
    case dongjak = "DONGJAK"
    case gwanak = "GWANAK"
    case seocho = "SEOCHO"
    case gangnam = "GANGNAM"
    case songpa = "SONGPA"
    case gangdong = "GANGDONG"
}

enum Category: String, Codable {
    case daily = "DAILY"
    case interview = "INTERVIEW"
    case actor = "ACTOR"
    case party = "PARTY"
    case wedding = "WEDDING"
    case prosthetic = "PROSTHETIC"
    case studio = "STUDIO"
    case etc = "ETC"
}

enum MakeupLocation: String, Codable {
    case shop = "SHOP"
    case visit = "VISIT"
    case both = "BOTH"
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
