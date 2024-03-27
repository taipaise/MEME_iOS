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
    case postReservation(parameters: [String: Any])
    case patchReservation(reservationId: Int, status: ReservationState)
    case getArtistReservation(aristId: Int)
    case getModelReservation(modelId: Int)
    case getModelDetailReservation(reservationId: Int)
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
        case .getModelDetailReservation(reservationId: let id):
            return "/\(id)/model/details"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getArtistReservation, .getModelReservation, .getPossibleLocation, .getPossibleTime, .patchReservation, .postReservation, .getModelDetailReservation:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getArtistReservation, .getModelReservation, .getPossibleLocation, .getPossibleTime, .getModelDetailReservation:
            return .get
        case .patchReservation:
            return .patch
        case .postReservation:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getArtistReservation, .getModelReservation, .getPossibleLocation, .getPossibleTime, .getModelDetailReservation:
            return .requestPlain
        case .patchReservation(reservationId: let id, status: let state):
            let parameters: [String: Any] = [
                "reservationId": id,
                "status": state.rawValue
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .postReservation(let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
