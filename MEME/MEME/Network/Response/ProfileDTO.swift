//
//  ProfileDTO.swift
//  MEME
//
//  Created by 정민지 on 2/19/24.
//

import Foundation

// MARK: -아티스트 프로필 조회 DTO
struct ArtistProfileDTO: Codable {
    let result: String
    let message: String
    let data: ArtistProfileData?
    let code: Int
}

struct ArtistProfileData: Codable {
    let artistId: Int
    let isFavorite: Bool
    let gender: String?
    let nickname: String?
    let profileImg: String?
    let introduction: String?
    let workExperience:  String?
    let shopLocation: String?
    let region: [String]?
    let specialization: [String]?
    let makeupLocation: String?
    let availableDayOfWeekAndTime: [String: String]?
    let simplePortfolioDtoList: [SimplePortfolioDTO]?
}

struct SimplePortfolioDTO: Codable {
    let portfolioId: Int
    let portfolioImg: String
    let category: String
    let makeupName: String
    let artistName: String
    let price: Int
    let makeupLocation: String?
}
