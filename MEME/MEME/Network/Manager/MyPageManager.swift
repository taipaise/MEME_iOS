//
//  MyPageManager.swift
//  MEME
//
//  Created by 임아영 on 2/9/24.
//

import Foundation
import Moya

final class MyPageManager {
    typealias API = MyPageAPI
    
    static let shared = MyPageManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func getMyPageProfile(userId: Int, completion: @escaping (Result<MyPageResponse, MoyaError>) -> Void) {
        provider.request(api: .getMyPageProfile(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let myPageResponse = try JSONDecoder().decode(MyPageResponse.self, from: response.data)
                    completion(.success(myPageResponse))
                } catch {
                    completion(.failure(MoyaError.objectMapping(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
