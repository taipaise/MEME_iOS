//
//  NetworkError.swift
//  MEME
//
//  Created by 이동현 on 1/30/24.
//

import Foundation
import Moya

enum NetworkError: Int {
    case invalidRequest = 400  // Bad Request
    case serverError    = 500  // Internal Server Error
}

struct HandleNetworkError {
    static func handleNetworkError(_ error: Error) {
        if let moyaError = error as? MoyaError {
            if let code = moyaError.response?.statusCode {
                let networkError = NetworkError(rawValue: code)
                switch networkError {
                case .invalidRequest:
                    print("invalidRequest")
                default:
                    print("network error")
                }
            }
        }
    }
}
