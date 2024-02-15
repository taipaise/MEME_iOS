//
//  PortfolioDTO.swift
//  MEME
//
//  Created by 정민지 on 2/14/24.
//

import Foundation

// MARK: -포트폴리오 세부 조회 DTO
struct PortfolioDTO: Codable {
    let result: String
    let message: String
    let data: PortfolioData?
    let statusCode: Int
}

struct PortfolioData: Codable {
    let portfolioId: Int
    let category: String
    let artistNickName: String
    let makeupName: String
    let price: Int
    let makeupLocation: String
    let shopLocation: String?
    let region: [String]?
    let isBlock: Bool
    let averageStars: String
    let reviewCount: Int
    let portfolioImgDtoList: [ImageData]?
}
