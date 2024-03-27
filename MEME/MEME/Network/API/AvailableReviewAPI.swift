//
//  AvailableReviewAPI.swift
//  MEME
//
//  Created by 임아영 on 3/10/24.
//

import Foundation
import Moya

enum AvailableReviewAPI {
    case getAvailableReview(modelId: Int, reservationId: Int, portfolioId: Int, artistNickName: String,
                            makeupName: String, portfolioImg: String, reservationDate: String, shopLocation: String)
}

extension AvailableReviewAPI: MemeAPI {
    var domain: MemeDomain {
        return .review
    }
    
    var urlPath: String {
        switch self {
        case .getAvailableReview(let modelId, _, _, _, _, _, _, _):
            return "/available/\(modelId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getAvailableReview:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAvailableReview:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getAvailableReview(let modelId, let reservationId, let portfolioId, let artistNickName,
                                 let makeupName, let reservationDate, let portfolioImg, let shopLocation):
            let parameters: [String: Any] = [
                "modelId": modelId,
                "reservationId": reservationId,
                "portfolioId": portfolioId,
                "artistNickName": artistNickName,
                "makeupName": makeupName,
                "reservationDate": reservationDate,
                "portfolioImg": portfolioImg,
                "shopLocation": shopLocation
                ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
