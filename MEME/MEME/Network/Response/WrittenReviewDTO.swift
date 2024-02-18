//
//  WrittenReviewDTO.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation

struct WrittenReviewResponse: Codable {
    let result: String
    let message: String
    let data: WrittenReviewData?
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case result, message, data, statusCode
    }
}
    
struct WrittenReviewData: Codable {
    let modelNickName: String
    let star: Int
    let comment: String
    let reviewImgDtoList: [ReviewImage]
}
