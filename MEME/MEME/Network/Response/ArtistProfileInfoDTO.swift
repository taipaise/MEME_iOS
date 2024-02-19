//
//  ArtistProfileInfoDTO.swift
//  MEME
//
//  Created by 임아영 on 2/19/24.
//
import Foundation

struct ArtistProfileInfoResponse: Codable {
    let result: String
    let message: String
    let data: ArtistProfileInfoData?
    let statusCode: Int
}

struct ArtistProfileInfoData: Codable {
    let userId: Int
    let profileImg: String
    let nickname: String
    let gender: Gender
    let introduction: String
    let workExperience: workExperience
    let region: [region]
    let specialization: [category]
    let makeupLocation: makeupLocation
    let shopLocation: String
    let availableDayOfWeek: [String: times]
}

enum region: String, CaseIterable, Codable {
    case JONGNO
    case JUNG
    case YONGSAN
    case SEONGDONG
    case GWANGJIN
    case DONGDAEMUN
    case JUNGNANG
    case SEONGBUK
    case GANGBUK
    case DOBONG
    case NOWON
    case EUNPYEONG
    case SEODAEMUN
    case MAPO
    case YANGCHEON
    case GANGSEO
    case GURO
    case GEUMCHEON
    case YEONGDEUNGPO
    case DONGJAK
    case GWANAK
    case SEOCHO
    case GANGNAM
    case SONGPA
    case GANGDONG
    
    var koreanName: String {
        switch self {
        case .JONGNO: return "종로구"
        case .JUNG: return "중구"
        case .YONGSAN: return "용산구"
        case .SEONGDONG: return "성동구"
        case .GWANGJIN: return "광진구"
        case .DONGDAEMUN: return "동대문구"
        case .JUNGNANG: return "중랑구"
        case .SEONGBUK: return "성북구"
        case .GANGBUK: return "강북구"
        case .DOBONG: return "도봉구"
        case .NOWON: return "노원구"
        case .EUNPYEONG: return "은평구"
        case .SEODAEMUN: return "서대문구"
        case .MAPO: return "마포구"
        case .YANGCHEON: return "양천구"
        case .GANGSEO: return "강서구"
        case .GURO: return "구로구"
        case .GEUMCHEON: return "금천구"
        case .YEONGDEUNGPO: return "영등포구"
        case .DONGJAK: return "동작구"
        case .GWANAK: return "관악구"
        case .SEOCHO: return "서초구"
        case .GANGNAM: return "강남구"
        case .SONGPA: return "송파구"
        case .GANGDONG: return "강동구"
        }
    }
}

enum category: String, Codable {
    case daily = "DAILY"
    case interview = "INTERVIEW"
    case actor = "ACTOR"
    case party = "PARTY"
    case wedding = "WEDDING"
    case prosthetic = "PROSTHETIC"
    case studio = "STUDIO"
    case etc = "ETC"
    
    var displayText: String {
        switch self {
        case .daily:
            return "데일리 메이크업"
        case .actor:
            return "배우 메이크업"
        case .interview:
            return "면접 메이크업"
        case .party:
            return "파티/이벤트 메이크업"
        case .wedding:
            return "웨딩 메이크업"
        case .prosthetic:
            return "특수 메이크업"
        case .studio:
            return "스튜디오 메이크업"
        case .etc:
            return "기타(속눈썹, 퍼스널컬러)"
        }
    }
}

enum workExperience: String, Codable {
    case zero = "ZERO"
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
    
    var displayText: String {
           switch self {
           case .zero: return "0년"
           case .one: return "1년"
           case .two: return "2년"
           case .three: return "3년"
           case .four: return "4년"
           case .five: return "5년"
           case .six: return "6년"
           case .seven: return "7년"
           case .eight: return "8년"
           case .nine: return "9년"
           case .ten: return "10년"
           }
       }
}

enum makeupLocation: String, Codable {
    case shop = "SHOP"
    case visit = "VISIT"
    case both = "BOTH"
    
    var displayText: String {
        switch self {
        case .shop:
            return "제가 다니는 샵에서 진행해요"
        case .visit:
            return "직접 방문해서 진행해요"
        case .both:
            return "둘 다 상관없어요"
        }
    }
}


enum ArtistDayOfWeek: String, Codable {
    case MON = "MON"
    case TUE = "TUE"
    case WED = "WED"
    case THU = "THU"
    case FRI = "FRI"
    case SAT = "SAT"
    case SUN = "SUN"
    
    var displayText: String {
        switch self {
        case .MON: return "월"
        case .TUE: return "화"
        case .WED: return "수"
        case .THU: return "목"
        case .FRI: return "금"
        case .SAT: return "토"
        case .SUN: return "일"
        }
    }
}
enum times: String, Codable {
    case _00_00 = "_00_00"
    case _04_00 = "_04_00"
    case _04_30 = "_04_30"
    case _05_00 = "_05_00"
    case _05_30 = "_05_30"
    case _06_00 = "_06_00"
    case _06_30 = "_06_30"
    case _07_00 = "_07_00"
    case _07_30 = "_07_30"
    case _08_00 = "_08_00"
    case _08_30 = "_08_30"
    case _09_00 = "_09_00"
    case _09_30 = "_09_30"
    case _10_00 = "_10_00"
    case _10_30 = "_10_30"
    case _11_00 = "_11_00"
    case _11_30 = "_11_30"
    case _12_00 = "_12_00"
    case _12_30 = "_12_30"
    case _13_00 = "_13_00"
    case _13_30 = "_13_30"
    case _14_00 = "_14_00"
    case _14_30 = "_14_30"
    case _15_00 = "_15_00"
    case _15_30 = "_15_30"
    case _16_00 = "_16_00"
    case _16_30 = "_16_30"
    case _17_00 = "_17_00"
    case _17_30 = "_17_30"
    case _18_00 = "_18_00"
    case _18_30 = "_18_30"
    case _19_00 = "_19_00"
    case _19_30 = "_19_30"
    case _20_00 = "_20_00"
    case _20_30 = "_20_30"
    case _21_00 = "_21_00"
    
    var displayText: String {
        switch self {
        case ._00_00: return "00:00"
        case ._04_00: return "04:00"
        case ._04_30: return "04:30"
        case ._05_00: return "05:00"
        case ._05_30: return "05:30"
        case ._06_00: return "06:00"
        case ._06_30: return "06:30"
        case ._07_00: return "07:00"
        case ._07_30: return "07:30"
        case ._08_00: return "08:00"
        case ._08_30: return "08:30"
        case ._09_00: return "09:00"
        case ._09_30: return "09:30"
        case ._10_00: return "10:00"
        case ._10_30: return "10:30"
        case ._11_00: return "11:00"
        case ._11_30: return "11:30"
        case ._12_00: return "12:00"
        case ._12_30: return "12:30"
        case ._13_00: return "13:00"
        case ._13_30: return "13:30"
        case ._14_00: return "14:00"
        case ._14_30: return "14:30"
        case ._15_00: return "15:00"
        case ._15_30: return "15:30"
        case ._16_00: return "16:00"
        case ._16_30: return "16:30"
        case ._17_00: return "17:00"
        case ._17_30: return "17:30"
        case ._18_00: return "18:00"
        case ._18_30: return "18:30"
        case ._19_00: return "19:00"
        case ._19_30: return "19:30"
        case ._20_00: return "20:00"
        case ._20_30: return "20:30"
        case ._21_00: return "21:00"
        }
    }
}
