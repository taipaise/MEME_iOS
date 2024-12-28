//
//  TokenResponseDTO.swift
//  MEME
//
//  Created by 이동현 on 2/18/24.
//

import Foundation

struct TokenResponseDTO: Codable {
    let access_token: String
    let refresh_token: String
    
    enum CodingKeys: String, CodingKey {
        case access_token, refresh_token
    }
}
