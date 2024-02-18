//
//  LogOutDTO.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
struct LogoutResponse: Codable {
    let code: Int
    let result: String
    let message: String
    let data: String?
}

