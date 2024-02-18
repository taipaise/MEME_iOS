//
//  InterestMakeUpDTO.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation

// MARK: - InterestMakeUpResponse

struct MakeupResponse: Codable {
    let result: String
    let message: String
    let data: MakeupData
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case result, message, data, statusCode
    }
}

// MARK: - InterestMakeUpData

struct MakeupData: Codable {
    let content: [MakeupContent]
    let currentPage: Int
    let pageSize: Int
    let totalNumber: Int
    let totalPage: Int
}

// MARK: - InterestMakeUpContent

struct MakeupContent: Codable {
    let portfolioId: Int
    let portfolioImg: String
    let category: String
    let makeupName: String
    let artistName: String
    let price: Int
    let makeupLocation: String
}
