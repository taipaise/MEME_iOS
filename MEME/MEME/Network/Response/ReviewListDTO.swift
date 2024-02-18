//
//  ReviewListDTO.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation

struct ReviewResponse: Codable {
    let result: String
    let message: String
    let data: ReviewListData?
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case result, message, data, statusCode
    }
}

struct ReviewListData: Codable {
    let content: [Review]
    let starStatus: [String: Int]
    let currentPage: Int
    let pageSize: Int
    let totalNumber: Int
    let totalPage: Int
}

struct Review: Codable {
    let modelName: String
    let star: Int
    let comment: String
    let reviewImgDtoList: [ReviewImage]
}

struct ReviewImage: Codable {
    let reviewImgSrc: String
    let delete: Bool
    let reviewImgId: Int
}
