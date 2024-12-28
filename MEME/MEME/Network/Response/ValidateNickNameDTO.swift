//
//  ValidateNickNameDTO.swift
//  MEME
//
//  Created by 정민지 on 12/29/24.
//

import Foundation

struct ValidateNickNameDTO: Codable {
    let code: Int
    let result:String
    let message: String
    let data: Bool
}
