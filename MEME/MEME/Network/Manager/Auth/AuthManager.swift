//
//  MyPageManager.swift
//  MEME
//
//  Created by 이동현 on 2/3/24.
//

import Foundation
import Moya

final class AuthManager {
    typealias API = AuthAPI
    
    static let shared = AuthManager()
    private let provider = NetworkProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    private init() {}
        
    func logout(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        
    }
    
    func withdraw(completion: @escaping (Result<Response, MoyaError>) -> Void) {
        
    }
    
    func modelSignUp(profileInfo: ProfileInfo) async -> Result<SignUpResponseDTO, Error> {
        let idToken = UserDefaultManager.shared.getIdToken()
        guard
            let socialProvider = UserDefaultManager.shared.getProvider(),
            !idToken.isEmpty
        else {
            return .failure(MEMEError.UserDefaultError)
        }
        
        let result = await provider.request(api: .modelSignUp(
            idToken: idToken,
            provider: socialProvider.rawValue,
            info: profileInfo))
        
        switch result {
        case .success(let response):
            do {
                let dto = try response.map(SignUpResponseDTO.self)
                return .success(dto)
            } catch {
                return .failure(MEMEError.failedToParse)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func artistsignUp(
        profileInfo: ProfileInfo,
        completion: @escaping (Result<SignUpResponseDTO, MoyaError>) -> Void
    ) {
       
    }
    
    func setArtistProfile(
        extraInfo: AtristProfileInfo,
        completion: @escaping (Result<ExtraProfileResponseDTO, MoyaError>) -> Void
    ) {
    }
    
    func reissue() async -> Result<Bool, Error> {
        guard
            let acccessToken = KeyChainManager.read(forkey: .accessToken),
            let refreshToken = KeyChainManager.read(forkey: .refreshToken)
        else {
            return .failure(MEMEError.KeychainError)
        }
        
        let result = await provider.request(api: .reissue(accessToken: acccessToken, refreshToken: refreshToken))
        
        switch result {
        case .success(let response):
            do {
                let tokenDTO = try response.map(TokenResponseDTO.self)
                KeyChainManager.save(forKey: .accessToken, value: tokenDTO.accessToken)
                KeyChainManager.save(forKey: .refreshToken, value: tokenDTO.refreshToken)
                return .success(true)
            } catch {
                return .failure(MEMEError.failedToParse)
            }
        case .failure(let error):
            return .failure(error)
        }

    }
    
    func checkIsUser(idToken: String, socialProvider: SocialProvider) async -> Result<CheckUserDTO, Error> {
        let result = await provider.request(api: .checkIsUser(idToken: idToken, provider: socialProvider))
        
        switch result {
        case .success(let response):
            do {
                let dto = try response.map(CheckUserDTO.self)
                return .success(dto)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
