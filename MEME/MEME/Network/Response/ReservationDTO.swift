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
    let data: [ReservationData]?
    let code: Int
}

struct ReservationData: Codable {
    let reservationId: Int
    let portfolioId: Int
    let modelNickName: String
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
    let code: Int
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
    let code: Int
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
    let code: Int
}

struct PostReservationData: Codable {
    let makeupName: String
    let artistNickName: String
    let location: String
    let reservationDate: String
    let reservationDayOfWeekAndTime: [String: String]
}
// MARK: -예약 상태 변경 DTO
struct PatchReservationDTO: Codable {
    let result: String
    let message: String
    let data: String?
    let code: Int
}

// MARK: -모델 예약 상세 조회 DTO
struct ReservationDetailDTO: Codable {
    let result: String
    let message: String
    let data: ReservationDetailData
    let code: Int
}

struct ReservationDetailData: Codable {
    let reservationId: Int
    let artistNickName: String
    let artistProfileImg: String?
    let portfolioName: String
    let category: String
    let location: String
}
