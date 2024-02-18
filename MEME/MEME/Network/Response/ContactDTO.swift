//
//  ContactDTO.swift
//  MEME
//
//  Created by 임아영 on 2/18/24.
//

import Foundation

struct ContactResponse: Codable {
    let result: String
    let message: String
    let data: String
    let statusCode: Int
}
