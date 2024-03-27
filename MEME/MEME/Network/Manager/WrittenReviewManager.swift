//
//  WrittenReviewManager.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

final class WrittenReviewManager {
    typealias API = WrittenReviewAPI
    
    static let shared = WrittenReviewManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}

func getWrittenReview(modelId: Int, reviewId: Int, artistNickName: String, makeupName: String, portfolioImg: String, location: String, createdAt: String, completion: @escaping (Result<WrittenReviewResponse, MoyaError>) -> Void) {
    provider.request(api: .getWrittenReview(modelId: modelId, reviewId: reviewId, artistNickName: artistNickName, makeupName: makeupName, portfolioImg: portfolioImg, location: location, createdAt: createdAt)) { result in
            switch result {
            case .success(let response):
                do {
                    let reviewResponse = try JSONDecoder().decode(WrittenReviewResponse.self, from: response.data)
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
