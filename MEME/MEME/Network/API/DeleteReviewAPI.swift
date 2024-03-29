//
//  DeleteReviewAPI.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

enum DeleteReviewAPI {
    case deleteReview(modelId: Int, reviewId: Int)
}

extension DeleteReviewAPI: MemeAPI {
    var domain: MemeDomain {
        return .review
    }
    
    var urlPath: String {
        switch self {
        case .deleteReview:
            return ""
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .deleteReview:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteReview:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .deleteReview(let modelId, let reviewId):
            let parameters: [String: Any] =  [
                "modelId" : modelId,
                "reviewId": reviewId
            ]
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}

