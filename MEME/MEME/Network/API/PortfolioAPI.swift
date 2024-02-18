//

//  PortfolioAPI.swift
//  MEME
//
//  Created by 정민지 on 2/14/24.
//

import Foundation
import Moya

enum PortfolioAPI {
    case getPortfolioDetail(
        userId: Int,
        portfolioId: Int
    )
}

extension PortfolioAPI: MemeAPI {
    var domain: MemeDomain {
        return .portfolio
    }
    
    var urlPath: String {
        switch self {

        case .getPortfolioDetail(userId: let userId, portfolioId: let portfolioId):
            return "/details/\(userId)/\(portfolioId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getPortfolioDetail:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPortfolioDetail:
            return .get

        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getPortfolioDetail(
            portfolioId: let portfolioId):
            var parameters: [String: Any] = ["portfolioId": portfolioId]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
