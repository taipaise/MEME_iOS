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
    let access_token: String?
    let refresh_token: String?
    let user_status: Bool
    let user_id: Int?
    let role: String?
}
