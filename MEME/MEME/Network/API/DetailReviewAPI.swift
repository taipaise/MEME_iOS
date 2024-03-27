//
//  DetailReviewAPI.swift
//  MEME
//
//  Created by 임아영 on 3/20/24.
//

import Foundation
import Moya

enum DetailReviewAPI {
    case getDetailReview(reviewId: Int, artistNickName: String, makeupName: String, star: Int, comment: String, reviewImgDtoList: [DetailReviewImage])
}

extension DetailReviewAPI: MemeAPI {
    var domain: MemeDomain {
        return .review
    }
    
    var urlPath: String {
        switch self {
        case .getDetailReview(let reviewId, _, _, _, _, _):
            return "/details/\(reviewId)"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .getDetailReview:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getDetailReview:
            return .get
        }
    }
    
    var task: Task {
           switch self {
           case .getDetailReview(let reviewId, let artistNickName,let makeupName, let star, let comment, let reviewImgDtoList):
               let parameters: [String: Any] = [
                   "reviewId": reviewId,
                   "artistNickName": artistNickName,
                   "makeupName": makeupName,
                   "star": star,
                   "comment": comment,
                   "reviewImgDtoList": reviewImgDtoList.map { ["reviewImgSrc": $0.reviewImgSrc, "delete": $0.delete, "reviewImgId": $0.reviewImgId] }
               ]
               return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}
