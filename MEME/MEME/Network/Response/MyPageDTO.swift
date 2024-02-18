//
//  MyPageAPI.swift
//  MEME
//
//  Created by 임아영 on 2/9/24.

import Foundation

struct MyPageResponse: Codable {
    let result: String
    let message: String
    let data: MyPageData?
    let statusCode: Int
}

struct MyPageData: Codable {
    let profileImg: String?
    let nickname: String?
    let name: String?
    let gender: String?
    let email: String?
}
// MARK: -관심 아티스트 조회 DTO
struct FavoriteArtistsDTO: Codable {
    let result: String
    let message: String
    let data: FavoriteArtistsData?
    let statusCode: Int
}

struct FavoriteArtistsData: Codable {
    let content: [Artist]?
    let currentPage: Int
    let pageSize: Int
    let totalNumber: Int
    let totalPage: Int
}

struct Artist: Codable {
    let artistId: Int
    let profileImg: String
    let artistNickName: String
}

// MARK: -관심 메이크업 추가, 삭제 DTO
struct FavoriteDTO: Codable {
    let result: String
    let message: String
    let data: String?
    let statusCode: Int
}

