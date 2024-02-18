//
//  InterestArtistManager.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation
import Moya

final class InterestArtistManager {
    typealias API = InterestArtistAPI
    
    static let shared = InterestArtistManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    func getInterestArtist(modelID: Int,artistId: Int, artistNickName: String, profileImg: String, completion: @escaping (Result<InterestArtistResponse, MoyaError>) -> Void) {
        provider.request(api: .getInterestArtist(modelId: modelID, artistId: artistId, artistNickName: artistNickName, profileImg: profileImg)) { result in
            switch result {
            case .success(let response):
                do {
                    let results = try JSONDecoder().decode(InterestArtistResponse.self, from: response.data)
                    completion(.success(results))
                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

