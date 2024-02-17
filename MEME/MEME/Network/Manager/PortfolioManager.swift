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
