//
//  ReservationAPI.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

enum DayOfWeek: String {
    case MON
    case TUE
    case WED
    case THU
    case FRI
    case SAT
    case SUN
}

enum ReservationState: String {
    case EXPECTED
    case COMPLETE
    case CANCEL
}
enum ReservationTimes: String {
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



enum ReservationAPI {
    case getPossibleLocation(aristId: Int)
    case getPossibleTime(aristId: Int)
    case postReservation(
        modelId: Int,
        portfolioId: Int,
        date: String,
        time: ReservationTimes,
        dayOfWeek: DayOfWeek,
        location: String
    )
    case patchReservation(reservationId: Int, status: ReservationState)
    case getArtistReservation(aristId: Int)
    case getModelReservation(modelId: Int)
}

extension ReservationAPI: MemeAPI {
    var domain: MemeDomain {
        return .reservation
    }
    
    var urlPath: String {
        switch self {
        case .getPossibleLocation(aristId: let id):
            return "/\(id)/location"
        case .getPossibleTime(aristId: let id):
            return "/\(id)/time"
        case .postReservation:
            return ""
        case .patchReservation:
            return "/alteration"
        case .getArtistReservation(aristId: let id):
            return "/\(id)/artist"
        case .getModelReservation(modelId: let id):
            return "/\(id)/model"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getArtistReservation, .getModelReservation, .getPossibleLocation, .getPossibleTime, .patchReservation, .postReservation:
            return .plain
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArtistReservation, .getModelReservation, .getPossibleLocation, .getPossibleTime:
            return .get
        case .patchReservation:
            return .patch
        case .postReservation:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getArtistReservation, .getModelReservation, .getPossibleLocation, .getPossibleTime:
            return .requestPlain
        case .patchReservation(reservationId: let id, status: let state):
            let parameters: [String: Any] = [
                "reservation_id": id,
                "status": state.rawValue
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .postReservation(
            modelId: let modelId,
            portfolioId: let portfolioId,
            date: let date,
            time: let time,
            dayOfWeek: let dayOfWeek,
            location: let location
        ):
            let reservationDayOfWeekAndTime: [String: Any] = [
                dayOfWeek.rawValue: time.rawValue,
            ]
            let parameters: [String: Any] = [
                "model_id" : modelId,
                "portfolio_id" : portfolioId,
                "reservation_date" : date,
                "reservationDayOfWeekAndTime": reservationDayOfWeekAndTime,
                "location" : location
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
