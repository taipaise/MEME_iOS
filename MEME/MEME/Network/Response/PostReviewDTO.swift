//
//  PostReviewDTO.swift
//  MEME
//
//  Created by 임아영 on 3/10/24.
//

import Foundation

struct ReviewRequestDTO: Codable {
    let modelId: Int
    let reservationId: Int
    let star: Int
    let comment: String
    let reviewImgSrc: [String]

    enum CodingKeys: String, CodingKey {
        case modelId = "model_id"
        case reservationId = "reservation_id"
        case star, comment
        case reviewImgSrc = "reviewImgSrc"
    }
}

struct ReviewResponseDTO: Codable {
    let code: Int
    let result: String
    let message: String
    let data: String?

    enum CodingKeys: String, CodingKey {
        case code, result, message, data
    }
}
