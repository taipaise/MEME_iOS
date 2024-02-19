//
//  PortfolioManager.swift
//  MEME
//
//  Created by 정민지 on 2/14/24.

//

import Foundation
import Moya

final class PortfolioManager {
    typealias API = PortfolioAPI
    
    static let shared = PortfolioManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    // MARK: -아티스트 추천 (리뷰순) API
    func getRecommendArtistByReview(
        completion: @escaping (Result<RecommendDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getRecommendArtistByReview) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(RecommendDTO.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -아티스트 추천 (최신 등록 순) API
    func getRecommendArtistByRecent(
        completion: @escaping (Result<RecommendDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getRecommendArtistByRecent) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(RecommendDTO.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -아티스트 추천 (리뷰순) API
    func getRecommendArtistByReview(
        completion: @escaping (Result<RecommendDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getRecommendArtistByReview) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(RecommendDTO.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: -아티스트 추천 (최신 등록 순) API
    func getRecommendArtistByRecent(
        completion: @escaping (Result<RecommendDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getRecommendArtistByRecent) { result in
            switch result {
            case .success(let response):
                do {
                    let response = try response.map(RecommendDTO.self)
                    completion(.success(response))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: -포트폴리오 세부 조회 API
    func getPortfolioDetail(userId: Int, portfolioId: Int, completion: @escaping (Result<PortfolioDTO, MoyaError>) -> Void) {
        provider.request(api: .getPortfolioDetail(userId: userId, portfolioId: portfolioId)) { result in
            switch result {
            case .success(let response):
                do {
                    let portfolioDetail = try JSONDecoder().decode(PortfolioDTO.self, from: response.data)
                    completion(.success(portfolioDetail))
                } catch let error {
                    completion(.failure(MoyaError.underlying(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
