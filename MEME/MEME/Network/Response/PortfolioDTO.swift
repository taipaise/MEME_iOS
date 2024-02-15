//
//  PortfolioDTO.swift
//  MEME
//
//  Created by 정민지 on 2/14/24.
//

import Foundation

// MARK: -포트폴리오 세부 조회 DTO
struct PortfolioDTO: Codable {
    let result: String
    let message: String
    let data: SearchResultData?
    let statusCode: Int
}
