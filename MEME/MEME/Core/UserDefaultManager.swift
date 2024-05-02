//
//  UserDefaultManager.swift
//  MEME
//
//  Created by 이동현 on 2/18/24.
//

import Foundation

final class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    private let userDefaults = UserDefaults.standard
    private let socialProvider = "Provider"
    private let idToken = "IdToken"
    
    func getProvider() -> SocialProvider? {
        let provider = userDefaults.string(forKey: socialProvider) ?? ""
        
        switch provider {
        case SocialProvider.APPLE.rawValue:
            return SocialProvider.APPLE
        case SocialProvider.KAKAO.rawValue:
            return SocialProvider.KAKAO
        default:
            return nil
        }
    }
    
    func saveProvider(_ provider: SocialProvider) {
        userDefaults.set(provider.rawValue, forKey: socialProvider)
    }
    
    func removeProvider() {
        userDefaults.removeObject(forKey: socialProvider)
    }
    
    func getIdToken() -> String {
        return userDefaults.string(forKey: idToken) ?? ""
    }
    
    func saveIdToken(_ id: String) {
        userDefaults.set(id, forKey: idToken)
    }
    
    func removeIdToken() {
        userDefaults.removeObject(forKey: idToken)
    }
    
    func removeAll() {
        removeProvider()
        removeIdToken()
    }
}
