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
    private let userIdKey = "ID"
    private let socialProvider = "Provider"
    
    func getId() -> String? {
        return userDefaults.string(forKey: userIdKey)
    }
    
    func saveId(_ id: String) {
        userDefaults.set(id, forKey: userIdKey)
    }
    
    func removeId() {
        userDefaults.removeObject(forKey: userIdKey)
    }
    
    func getProvider() -> String? {
        return userDefaults.string(forKey: socialProvider)
    }
    
    func saveProvider(_ provider: String) {
        userDefaults.set(provider, forKey: userIdKey)
    }
    
    func removeProvider() {
        userDefaults.removeObject(forKey: socialProvider)
    }
}
