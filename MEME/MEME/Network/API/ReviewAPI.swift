//
//  ReviewAPI.swift
//  MEME
//
//  Created by 정민지 on 3/22/24.
//

import Foundation
import Moya

enum ReviewAPI {
    case getPortfolioReview(portfolioId: Int, page: Int)
}

extension ReviewAPI: MemeAPI {
    var domain: MemeDomain {
        return .review
    }
    
    var urlPath: String {
        switch self {
        case .getPortfolioReview(let portfolioId, _):
            return "/\(portfolioId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getPortfolioReview:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPortfolioReview:
            return .get
        }
    }
    
    var task: Task {
           switch self {
           case .getPortfolioReview(let portfolioId, let page):
               let parameters: [String: Any] = [
                   "portfolioId": portfolioId,
                   "page": page
               ]
               return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
