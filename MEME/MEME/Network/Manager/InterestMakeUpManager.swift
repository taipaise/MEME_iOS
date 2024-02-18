//
//  InterestMakeUpManager.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation

import Moya

final class InterestMakeUpManager {
    typealias API = InterestMakeUpAPI
    
    static let shared = InterestMakeUpManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func getInterestMakeUp(modelId: Int, portfolioId: Int, portfolioImg: String, category: String, makeupName: String, artistName: String, price: Int, makeupLocation: String,
                           completion: @escaping (Result<MakeupResponse, MoyaError>) -> Void) {
        provider.request(api: .getInterestMakeUp(modelId: modelId, portfolioId: portfolioId, portfolioImg: portfolioImg,  category: category, makeupName: makeupName, artistName: artistName, price: price, makeupLocation: makeupLocation)) { result in
            switch result {
            case .success(let response):
                do {
                    let results = try JSONDecoder().decode(MakeupResponse.self, from: response.data)
                    completion(.success(results))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

