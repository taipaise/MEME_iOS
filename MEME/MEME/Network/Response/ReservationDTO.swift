//
//  ReservationDTO.swift
//  MEME
//
//  Created by 정민지 on 2/10/24.
//

import Foundation

// MARK: -모델 예약 조회 DTO
struct ReservationDTO: Codable {
    let result: String
    let message: String
    var data: [ReservationData]?

    enum CodingKeys: String, CodingKey {
        case result, message, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        result = try container.decode(String.self, forKey: .result)
        message = try container.decode(String.self, forKey: .message)
        
        if let dataValue = try? container.decodeIfPresent([ReservationData].self, forKey: .data) {
            data = dataValue
        } else {
            data = nil
        }
    }
}

struct ReservationData: Codable {
    let reservationId: Int
    let portfolioId: Int
    let modelName: String
    let artistNickName: String
    let makeupName: String
    let price: Int
    let reservationDate: String
    let reservationDayOfWeekAndTime: [String: String]
    let shopLocation: String
    let status: String
}

// MARK: -아티스트 예약 가능 장소 조회 DTO
struct PossibleLocationsDTO: Codable {
    let result: String
    let message: String
    let data: MakeupLocationData
    let statusCode: Int
}

struct MakeupLocationData: Codable {
    let makeupLocation: String
    let shopLocation: String
    let region: [String]
}

// MARK: -아티스트 예약 가능 시간 조회 DTO
struct PossibleTimesDTO: Codable {
    let result: String
    let message: String
    let data: [TimeSlot]
    let statusCode: Int
}

struct TimeSlot: Codable {
    let availableDayOfWeek: String
    let availableTime: String
}

// MARK: -예약하기 DTO
struct PostReservationDTO: Codable {
    let result: String
    let message: String
    let data: PostReservationData?
    let statusCode: Int

    struct PostReservationData: Codable {
        let makeupName: String
        let artistNickName: String
        let location: String
        let reservationDate: String
        let reservationDayOfWeekAndTime: DayOfWeekTime
    }
    
    struct DayOfWeekTime: Codable {
        let MON: String?
        let TUE: String?
        let WED: String?
        let THU: String?
        let FRI: String?
        let SAT: String?
        let SUN: String?
    }
}
