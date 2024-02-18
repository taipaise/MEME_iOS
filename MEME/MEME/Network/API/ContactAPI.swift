//
//  ContactAPI.swift
//  MEME
//
//  Created by 임아영 on 2/18/24.
//

import Foundation
import Moya

enum ContactAPI {
    case postContact(userId: Int, inquiryTitle: String, inquiryText: String)

}

extension ContactAPI: MemeAPI {
    var domain: MemeDomain {
        return .mypage
    }
    
    var urlPath: String {
        switch self {
        case .postContact:
            return "/contact"
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self {
        case .postContact:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postContact:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .postContact(userId, inquiryTitle, inquiryText):
            let parameters: [String: Any] = ["userId": userId,
                                             "inquiryTitle": inquiryTitle,
                                             "inquiryText": inquiryText]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
}
