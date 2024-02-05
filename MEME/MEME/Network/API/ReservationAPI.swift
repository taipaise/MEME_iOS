//
//  ReservationAPI.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

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
