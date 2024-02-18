//
//  LogOutManager.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

final class LogOutManager {
    typealias API = LogOutAPI
    
    static let shared = LogOutManager()
    let provider = NetworkAuthProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func a(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        provider.request(api: .logOut) { result in
            completion(result)
        }
    }
}
