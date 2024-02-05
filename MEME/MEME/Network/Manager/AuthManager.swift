//
//  MyPageManager.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

final class AuthManager {
    typealias API = AuthAPI
    
    static let shared = AuthManager()
    let provider = NetworkAuthProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func a(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(api: .kakakoLogin) { result in
            completion(result)
        }
    }
}
