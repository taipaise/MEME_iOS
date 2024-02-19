//
//  ArtistProfileInfoManager.swift
//  MEME
//
//  Created by 임아영 on 2/19/24.
//

import Foundation
import Moya

final class ArtistProfileInfoManager {
    typealias API = ArtistProfileInfoAPI
    
    static let shared = ArtistProfileInfoManager()
    
    let plugin = NetworkLoggerPlugin(configuration: .init(formatter: .init(), output: { (type, items) in
        for item in items {
            print(item)
        }
    }, logOptions: .verbose))
    
    let provider: MoyaProvider<API>
        
    private init() {self.provider = MoyaProvider<API>(plugins: [plugin])}
    
    func getArtistProfileInfo(userId: Int, completion: @escaping (Result<ArtistProfileInfoResponse, MoyaError>) -> Void) {
        provider.request(.getArtistProfileInfo(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let results = try JSONDecoder().decode(ArtistProfileInfoResponse.self, from: response.data)
                    completion(.success(results))
                } catch {
                    print(error)
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
