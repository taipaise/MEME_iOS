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
    private let isLogin = "isLogin"
    
    func getProvider() -> String? {
        return userDefaults.string(forKey: socialProvider)
    }
    
    func saveProvider(_ provider: String) {
        userDefaults.set(provider, forKey: socialProvider)
    }
    
    func removeProvider() {
        userDefaults.removeObject(forKey: socialProvider)
    }
    
    func getIdToken() -> String? {
        return userDefaults.string(forKey: idToken)
    }
    
    func saveIdToken(_ id: String) {
        userDefaults.set(id, forKey: idToken)
    }
    
    func removeIdToken() {
        userDefaults.removeObject(forKey: idToken)
    }
    
    func getIsLogin() -> Bool? {
        let state = userDefaults.string(forKey: isLogin)
        return state == "TRUE"
    }
    
    func saveIsLogin(_ isLogin: String) {
        userDefaults.set(isLogin, forKey: isLogin)
    }
    
    func removeIsLogin() {
        userDefaults.removeObject(forKey: isLogin)
    }
}
