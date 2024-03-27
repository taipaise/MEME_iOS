//
//  AvailableReviewDTO.swift
//  MEME
//
//  Created by 임아영 on 3/10/24.
//
import Foundation

struct AvailableReviewResponse: Codable {
    let result: String
    let message: String
    let data: AvailableReviewResponseData?
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case result, message, data, statusCode
    }
}

struct AvailableReviewResponseData: Codable {
    let reservationId: Int
    let portfolioId: Int
    let artistNickName: String
    let makeupName: String
    let portfolioImg: String
    let reservationDate: String
    let shopLocation: String
}
