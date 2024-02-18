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

func getReviews(modelId: Int, modelNickName: String, star: Int, comment: String, reviewImgDtoList: [ReviewImage], completion: @escaping (Result<ReviewResponse, MoyaError>) -> Void) {
    provider.request(api: .getWrittenReview(modelId: modelId, modelNickName: modelNickName, star: star, comment: comment, reviewImgDtoList: reviewImgDtoList)) { result in
            switch result {
            case .success(let response):
                do {
                    let reviewResponse = try JSONDecoder().decode(ReviewResponse.self, from: response.data)
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
