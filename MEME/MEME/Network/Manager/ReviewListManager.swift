//
//  ReviewListManager.swift
//  MEME
//
//  Created by 임아영 on 2/17/24.
//

import Foundation
import Moya

final class ReviewListManager {
    typealias API = ReviewListAPI
    
    static let shared = ReviewListManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func getReviews(portfolioId: Int, modelName: String, star: Int, comment: String, reviewImgDtoList: [ReviewImage], completion: @escaping (Result<ReviewResponse, MoyaError>) -> Void) {
        provider.request(api: .getIReviewList(portfolioId: portfolioId, modelName: modelName, star: star, comment: comment, reviewImgDtoList: reviewImgDtoList)) { result in
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
