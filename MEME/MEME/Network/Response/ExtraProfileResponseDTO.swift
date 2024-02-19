//
//  ExtraProfileResponseDTO.swift
//  MEME
//
//  Created by 이동현 on 2/19/24.
//

import Foundation

struct ExtraProfileResponseDTO: Codable {
    let code: Int
    let result: String
    let message: String
    let data: String
    
    enum CodingKeys: String, CodingKey {
        case code, result, message, data
    }
}
