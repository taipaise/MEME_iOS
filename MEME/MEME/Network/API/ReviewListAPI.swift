//
//  ReviewListAPI.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

enum ReviewListAPI {
    case getIReviewList(portfolioId: Int, modelName: String, star: Int, comment: String, reviewImgDtoList: [ReviewImage])
}

extension ReviewListAPI: MemeAPI {
    var domain: MemeDomain {
        return .review
    }
    
    var urlPath: String {
        switch self {
        case .getIReviewList(let portfolioId, _, _, _, _):
            return "/\(portfolioId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getIReviewList:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getIReviewList:
            return .get
        }
    }
    
    var task: Task {
           switch self {
           case .getIReviewList(let portfolioId, let modelName, let star, let comment, let reviewImgDtoList):
               let parameters: [String: Any] = [
                   "portfolioId": portfolioId,
                   "modelName": modelName,
                   "star": star,
                   "comment": comment,
                   "reviewImgDtoList": reviewImgDtoList.map { ["reviewImgSrc": $0.reviewImgSrc, "delete": $0.delete, "reviewImgId": $0.reviewImgId] }
               ]
               return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
