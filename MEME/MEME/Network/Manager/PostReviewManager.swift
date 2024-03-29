//
//  PostReviewManager.swift
//  MEME
//
//  Created by 임아영 on 3/10/24.
//

import Foundation
import Moya

final class PostReviewManager {
    typealias API = PostReviewAPI
    
    static let shared = PostReviewManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func postReview(modelId: Int, reservationId: Int, star: Int, comment: String, reviewImgSrc: [String],
                    completion: @escaping (Result<ReviewResponseDTO, MoyaError>) -> Void) {
        provider.request(api: .postReview(modelId: modelId, reservationId: reservationId, star: star, comment: comment, reviewImgSrc: reviewImgSrc)) { result in
            switch result {
            case .success(let response):
                do {
                    let reviewResponse = try JSONDecoder().decode(ReviewResponseDTO.self, from: response.data)
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
