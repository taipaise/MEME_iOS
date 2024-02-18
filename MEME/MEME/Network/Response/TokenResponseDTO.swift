//
//  TokenResponseDTO.swift
//  MEME
//
//  Created by 이동현 on 2/18/24.
//

import Foundation

struct TokenResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken, refreshToken
    }
}
