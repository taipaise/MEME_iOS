//
//  ProfileManager.swift
//  MEME
//
//  Created by 임아영 on 2/14/24.
//

import Foundation
import Moya

final class ModelProfileManager {
    typealias API = ModelProfileAPI
    
    static let shared = ModelProfileManager()
    let plugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    let provider: MoyaProvider<API>
        
        private init() {
            let plugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
            provider = MoyaProvider<API>(plugins: [plugin])
        }
//    let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
//    private init() {}
    
    func patchProfile(userId: Int, profileImg: String?, nickname: String?, gender: String?, skinType: String?, personalColor: String?, completion: @escaping (Result<ModelProfileResponse, MoyaError>) -> Void) {
        provider.request(.patchProfile(userId: userId, profileImg: profileImg, nickname: nickname, gender: gender, skinType: skinType, personalColor: personalColor)) { result in
            switch result {
            case .success(let response):
                do {
                    let profileResponse = try JSONDecoder().decode(ModelProfileResponse.self, from: response.data)
                    completion(.success(profileResponse))
                } catch {
                    completion(.failure(MoyaError.objectMapping(error, response)))
                }
            case .failure(let error):
                if let response = error.response {
                    let responseBody = String(data: response.data, encoding: .utf8)
                    print("Response body: \(responseBody ?? "")")
                }
                completion(.failure(error))

//            case .failure(let error):
//                completion(.failure(error))
            }
        }
    }
}
