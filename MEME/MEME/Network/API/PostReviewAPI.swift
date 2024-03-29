//
//  PostReviewAPI.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

enum PostReviewAPI {
    case postReview(modelId: Int, reservationId: Int, star: Int, comment: String, reviewImgSrc: [String])
}

extension PostReviewAPI: MemeAPI {
    var domain: MemeDomain {
        return .review
    }
    
    var urlPath: String {
        switch self {
        case .postReview:
            return ""
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .postReview:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postReview:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postReview(let modelId, let reservationId, let star, let comment, let reviewImgSrc):
            let parameters: [String: Any] = [
                "model_id": modelId,
                "reservation_id": reservationId,
                "star": star,
                "comment": comment,
                "reviewImgSrc": reviewImgSrc
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}


