//
//  DetailReviewDTO.swift
//  MEME
//
//  Created by 임아영 on 3/20/24.
//

import Foundation

struct DetailReviewResponse: Codable {
    let result: String
    let message: String
    let data: DetailReviewData?
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case result, message, data, code
    }
}

struct DetailReviewData: Codable {
    let artistNickName: String
    let makeupName: String
    let star: Int
    let comment: String
    let reviewImgDtoList: [ReviewImage]
}

struct DetailReviewImage: Codable {
    let reviewImgSrc: String
    let delete: Bool
    let reviewImgId: Int
}
