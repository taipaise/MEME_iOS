//
//  WrittenReviewAPI.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

enum WrittenReviewAPI {
    case getWrittenReview(modelId: Int, reviewId:Int, artistNickName: String, makeupName: String, portfolioImg: String,
                          location: String ,createdAt: String)
}

extension WrittenReviewAPI: MemeAPI {
    var domain: MemeDomain {
        return .review
    }
    
    var urlPath: String {
        switch self {
        case .getWrittenReview(let modelId, _, _, _, _, _, _):
            return "/me/\(modelId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getWrittenReview:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWrittenReview:
            return .get
        }
    }
    
    var task: Task {
           switch self {
           case .getWrittenReview(let modelId, let reviewId, let artistNickName, let makeupName, let portfolioImg,
                                  let location, let createdAt):
               let parameters: [String: Any] = [
                   "modelId": modelId,
                   "reviewId": reviewId,
                   "artistNickName": artistNickName,
                   "makeupName": makeupName,
                   "portfolioImg":portfolioImg,
                   "location": location,
                   "createdAt": createdAt
               ]
               return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
