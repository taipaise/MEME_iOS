//
//  File.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//


import Foundation

// MARK: - InterestArtistResponse

struct InterestArtistResponse: Codable {
    let result: String
    let message: String
    let data: ArtistData?
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case result, message, data, statusCode
    }
}

// MARK: - InterestArtistData

struct ArtistData: Codable {
    let content: [ArtistContent]
    let currentPage: Int
    let pageSize: Int
    let totalNumber: Int
    let totalPage: Int
}

// MARK: - InterestArtistContent

struct ArtistContent: Codable {
    let artistId: Int
    let profileImg: String
    let artistNickName: String
  
}
