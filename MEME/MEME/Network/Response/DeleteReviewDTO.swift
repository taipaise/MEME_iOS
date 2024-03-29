//
//  DeleteReviewDTO.swift
//  MEME
//
//  Created by 임아영 on 3/10/24.
//


struct DeleteReviewRequestDTO: Codable {
    let modelId: Int
    let reviewId: Int
  
    enum CodingKeys: String, CodingKey {
        case modelId = "model_id"
        case reviewId = "review_id"
    }
}

struct DeleteReviewResponseDTO: Codable {
    let result: String
    let message: String
    let data: String
    let code: Int

    enum CodingKeys: String, CodingKey {
        case code, result, message, data
    }
}
