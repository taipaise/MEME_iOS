//
//  PortfolioDTO.swift
//  MEME
//
//  Created by 정민지 on 2/14/24.
//

import Foundation

struct CreatePortfolioDTO: Codable {
    let statusCode: Int
    let result: String
    let message: String
    let data: Int
}

struct GetAllPortfolioDTO: Codable {
    let result: String
    let message: String
    let data: PortfolioAllDTO?
    let statusCode: Int
}
struct PortfolioAllDTO: Codable {
    let content: [PortfolioAllData]?
    let currentPage: Int
    let pageSize: Int
    let totalNumber: Int?
    let totalPage: Int
}
struct EditPortfolioDTO: Codable {
    struct Response: Codable {
        let code: Int
        let result: String
        let message: String
        let data: PortfolioData?
    }
}
struct PortfolioAllData: Codable {
    let portfolioId: Int
    let category, artistNickName: String
    let userId: Int
    let makeupName: String
    let price: Int
    let makeupLocation, shopLocation: String
    let region: [String]
    let isBlock: Bool
    let averageStars: String
    let reviewCount: Int
    let portfolioImgDtoList: [PortfolioImgDtoList]
}
struct PortfolioImgDtoList: Codable {
    let portfolioImgId: Int
    let portfolioImgSrc: String
    let delete: Bool
}
// MARK: -아티스트 추천 DTO
struct RecommendDTO: Codable {
    let result: String
    let message: String
    let data: [Portfolio]
    let statusCode: Int
}

struct Portfolio: Codable {
    let portfolioId: Int
    let portfolioImg: String
    let category: String
    let makeupName: String
    let artistName: String
    let price: Int
    let makeupLocation: String?
}

// MARK: -포트폴리오 세부 조회 DTO
struct PortfolioDTO: Codable {
    let result: String
    let message: String
    let data: PortfolioData?
    let statusCode: Int
}

struct PortfolioData: Codable {
    let portfolioId: Int
    let userId: Int
    let isFavorite: Bool
    let category: String
    let artistProfileImg: String
    let artistNickName: String
    let makeupName: String
    let price: Int
    let info: String
    let makeupLocation: String?
    let shopLocation: String?
    let region: [String]?
    let isBlock: Bool
    let averageStars: String
    let reviewCount: Int
    let portfolioImgDtoList: [ImageData]?
}
