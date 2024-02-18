//
//  WrittenReviewAPI.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

enum WrittenReviewAPI {
    case getWrittenReview(modelId: Int, modelNickName: String, star: Int, comment: String, 
                          reviewImgDtoList: [ReviewImage])
}

extension WrittenReviewAPI: MemeAPI {
    var domain: MemeDomain {
        return .review
    }
    
    var urlPath: String {
        switch self {
        case .getWrittenReview(let modelId, _, _, _, _):
            return "/\(modelId)"
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
           case .getWrittenReview(let modelId, let modelNickName, let star, let comment, let reviewImgDtoList):
               let parameters: [String: Any] = [
                   "modelId": modelId,
                   "modelNickName": modelNickName,
                   "star": star,
                   "comment": comment,
                   "reviewImgDtoList": reviewImgDtoList.map { ["reviewImgSrc": $0.reviewImgSrc, "delete": $0.delete, "reviewImgId": $0.reviewImgId] }
               ]
               return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
