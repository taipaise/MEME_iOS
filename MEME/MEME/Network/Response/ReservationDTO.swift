//
//  ReservationDTO.swift
//  MEME
//
//  Created by 정민지 on 2/10/24.
//

import Foundation

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

