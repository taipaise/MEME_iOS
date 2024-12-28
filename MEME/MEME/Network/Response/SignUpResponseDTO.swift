//
//  SignUpResponseDTO.swift
//  MEME
//
//  Created by 이동현 on 2/17/24.
//

import Foundation

struct SignUpResponseDTO: Codable {
    let code: Int
    let result: String
    let message: String
    let data: UserIdResponseDTO
    
    
    enum CodingKeys: String, CodingKey {
        case code, result, message, data
    }
}

struct UserIdResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let userId: Int
    let details: Bool
    let role: RoleType
    
    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken, userId, details, role
    }
}
