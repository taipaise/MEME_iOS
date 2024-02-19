//
//  ProfileManager.swift
//  MEME
//
//  Created by 정민지 on 2/19/24.
//

import Foundation
import Moya

final class ProfileManager {
    typealias API = ProfileAPI
    
    static let shared = ProfileManager()
    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
    
    // MARK: -아티스트 프로필 조회 API
    func getArtistProfile(
        userId: Int,
        artistId: Int,
        completion: @escaping (Result<ArtistProfileDTO, MoyaError>) -> Void
    ) {
        provider.request(api: .getArtistProfile(userId: userId, artistId: artistId)) { result in
            switch result {
            case .success(let response):
                do {
                    let profile = try JSONDecoder().decode(ArtistProfileDTO.self, from: response.data)
                    completion(.success(profile))
                } catch let error {
                    completion(.failure(MoyaError.underlying(error, response)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
