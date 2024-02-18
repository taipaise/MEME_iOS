//
//  ModelProfileInfoManager.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

final class ModelProfileInfoManager {
    typealias API = ModelProfileInfoAPI
    
    static let shared = ModelProfileInfoManager()
    
    let plugin = NetworkLoggerPlugin(configuration: .init(formatter: .init(), output: { (type, items) in
        for item in items {
            print(item)
        }
    }, logOptions: .verbose))
    
    let provider: MoyaProvider<API>
    
    //    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {self.provider = MoyaProvider<API>(plugins: [plugin])}
    
    func getModelProfileInfo(userId: Int, completion: @escaping (Result<ModelProfileInfoResponse, MoyaError>) -> Void) {
        provider.request(.getModelProfileInfo(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let results = try JSONDecoder().decode(ModelProfileInfoResponse.self, from: response.data)
                    completion(.success(results))
                } catch {
                    print(error)
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

