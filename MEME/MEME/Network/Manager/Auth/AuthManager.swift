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
    
    func validateUser(
        idToken: String,
        socialProvider: SocialProvider
    ) async -> Result<CheckUserDTO, Error> {
        let result = await provider.request(
            api: .validateUser(
                idToken: idToken,
                provider: socialProvider
            )
        )
        
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
    
    func validateNickname( nickname: String ) async -> Result<Bool, Error> {
        let result = await provider.request( api: .validateNickname( nickname: nickname )
        )
        
        switch result {
        case .success(let response):
            do {
                let dto = try response.map(ValidateNickNameDTO.self)
                return .success(dto.data)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
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
                let tokenDTO = try response.map(BasicResponseDTO<TokenResponseDTO>.self)
                KeyChainManager.save(forKey: .accessToken, value: tokenDTO.data.access_token)
                KeyChainManager.save(forKey: .refreshToken, value: tokenDTO.data.refresh_token)
                return .success(true)
            } catch {
                return .failure(MEMEError.failedToParse)
            }
        case .failure(let error):
            return .failure(error)
        }

    }
        
    func logout() async -> Result<Bool, Error> {
        let result = await provider.request(api: .logout)
        switch result {
        case .success:
            KeyChainManager.removeAllKeychain()
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }

    func leave() async -> Result<Bool, Error> {
        let result = await provider.request(api: .leave)
        switch result {
        case .success:
            KeyChainManager.removeAllKeychain()
            return .success(true)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func socialSingUp(profileInfo: SignUpProfileInfo) async -> Result<SignUpResponseDTO, Error> {
        let idToken = UserDefaultManager.shared.getIdToken()
        guard
            let socialProvider = UserDefaultManager.shared.getProvider(),
            !idToken.isEmpty
        else {
            return .failure(MEMEError.UserDefaultError)
        }
        
        let result = await provider.request(
            api: .socialSingUp(
                idToken: idToken,
                provider: socialProvider,
                role: profileInfo.roleType,
                username: profileInfo.username,
                nickname: profileInfo.username,
                profileImg: profileInfo.profileImg
            )
        )
        
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
}
