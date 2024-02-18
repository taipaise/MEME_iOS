//
//  MyPageAPI.swift
//  MEME
//
//  Created by 임아영 on 2/9/24.
//

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
