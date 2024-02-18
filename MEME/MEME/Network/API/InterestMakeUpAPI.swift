//
//  InterestMakeUpAPI.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation
import Moya

enum InterestMakeUpAPI {
    case getInterestMakeUp(modelId: Int, portfolioId: Int, portfolioImg: String , category: String, makeupName: String, artistName: String, price: Int, makeupLocation: String)
}

extension InterestMakeUpAPI: MemeAPI {
    var domain: MemeDomain {
        return .mypage
    }

    var urlPath: String {
        switch self {
        case .getInterestMakeUp(let modelId, _, _, _, _, _, _, _):
            return "/\(modelId)/favorite/portfolio"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getInterestMakeUp:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getInterestMakeUp:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .getInterestMakeUp(_, let portfolioId, let portfolioImg, let category, let makeupname, let artistname, let price, let makeupLocation):
            return .requestParameters(parameters: ["portfolioId": portfolioId, "category": category,  "makeupname": makeupname, "artistname": artistname, "price": price, "portfolioImg": portfolioImg, makeupLocation: "makeupLocation"], encoding: URLEncoding.queryString)
        }
    }
}
