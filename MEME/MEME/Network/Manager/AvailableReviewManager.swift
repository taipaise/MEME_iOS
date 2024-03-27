//
//  AvailableReviewManager.swift
//  MEME
//
//  Created by 임아영 on 3/10/24.
//

import Foundation
import Moya

final class AvailableReviewManager {
    typealias API = AvailableReviewAPI
    
    static let shared = AvailableReviewManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}

func getAvailableReview(modelId: Int, reservationId: Int, portfolioId: Int, artistNickName: String,
                        makeupName: String, reservationDate: String, portfolioImg: String, shopLocation: String,
                        completion: @escaping (Result<AvailableReviewResponse, MoyaError>) -> Void) {
    provider.request(api: .getAvailableReview(modelId: modelId, reservationId: reservationId, portfolioId: portfolioId, artistNickName: artistNickName, makeupName: makeupName, portfolioImg: portfolioImg, reservationDate: reservationDate, shopLocation: shopLocation)) { result in
            switch result {
            case .success(let response):
                do {
                    let reviewResponse = try JSONDecoder().decode(AvailableReviewResponse.self, from: response.data)
                    completion(.success(reviewResponse))
                } catch {
                    completion(.failure(MoyaError.objectMapping(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
