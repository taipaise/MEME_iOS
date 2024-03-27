//
//  DetailReviewManager.swift
//  MEME
//
//  Created by 임아영 on 3/20/24.
//

import Foundation
import Moya

final class DetailReviewManager {
    typealias API = DetailReviewAPI
    
    static let shared = DetailReviewManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func getDetailReview(reviewId: Int, artistNickName: String, makeupName: String, star: Int, comment: String, reviewImgDtoList: [DetailReviewImage], completion: @escaping (Result<DetailReviewResponse, MoyaError>) -> Void) {
        provider.request(api: .getDetailReview(reviewId: reviewId, artistNickName: artistNickName, makeupName: makeupName, star: star, comment: comment, reviewImgDtoList: reviewImgDtoList)) { result in
            switch result {
            case .success(let response):
                do {
                    let reviewResponse = try JSONDecoder().decode(DetailReviewResponse.self, from: response.data)
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
