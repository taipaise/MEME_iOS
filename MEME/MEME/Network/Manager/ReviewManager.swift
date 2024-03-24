//
//  ReviewManager.swift
//  MEME
//
//  Created by 정민지 on 3/22/24.
//

import Foundation
import Moya

final class ReviewManager {
    typealias API = ReviewAPI
    
    static let shared = ReviewManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func getReviews(portfolioId: Int, page: Int, completion: @escaping (Result<ReviewResponse, MoyaError>) -> Void) {
        provider.request(api: .getPortfolioReview(portfolioId: portfolioId, page: page)) { result in
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
