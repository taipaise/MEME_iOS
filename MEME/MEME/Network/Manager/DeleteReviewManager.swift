//
//  DeleteReviewManager.swift
//  MEME
//
//  Created by 임아영 on 3/10/24.
//

import Foundation
import Moya

final class DeleteReviewManager {
    typealias API = DeleteReviewAPI
    
    static let shared = DeleteReviewManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func deleteReview(
        modelId: Int,
        reviewId: Int,
        completion: @escaping (Result<DeleteReviewResponseDTO, MoyaError>) -> Void) {
        provider.request(api: .deleteReview(modelId: modelId, reviewId: reviewId)) { result in
            switch result {
            case .success(let response):
                do {
                    let reviewResponse = try JSONDecoder().decode(DeleteReviewResponseDTO.self, from: response.data)
                    completion(.success(reviewResponse))
                } catch {
                    print("디코딩 에러")
                    completion(.failure(MoyaError.objectMapping(error, response)))
                }
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
}

