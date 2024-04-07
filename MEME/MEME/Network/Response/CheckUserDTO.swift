//
//  LoginDTO.swift
//  MEME
//
//  Created by 이동현 on 3/28/24.
//

import Foundation

struct CheckUserDTO: Codable {
    let code: Int
    let result:String
    let message: String
    let data: IsUserDTO
}

// MARK: - DataClass
struct IsUserDTO: Codable {
    let userId: Int
    let role: String
    let accessToken: String
    let refreshToken: String
    let user: Bool
}