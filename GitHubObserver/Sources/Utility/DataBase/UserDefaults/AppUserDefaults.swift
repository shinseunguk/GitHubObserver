//
//  AppUserDefaults.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 10/16/24.
//

import Foundation

final class AppUserDefaults {
    static let shared = AppUserDefaults()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Keys
    private struct Keys {
        static let token = "Token"
        static let owner = "Owner"
    }
    
    // MARK: - 헤더 정보의 member
    func setToken(_ token: String) {
        userDefaults.set(token, forKey: Keys.token)
    }
    
    func getToken() -> String? {
        return userDefaults.string(forKey: Keys.token)
    }
    
    func removeToken() {
        userDefaults.removeObject(forKey: Keys.token)
    }
    
    func setOwner(_ owner: Owner) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(owner) {
            userDefaults.set(encoded, forKey: Keys.owner)
        }
    }

    func getOwner() -> Owner? {
        
        if let savedProfile = userDefaults.object(forKey: Keys.owner) as? Data {
            let decoder = JSONDecoder()
            
            if let loadedProfile = try? decoder.decode(Owner.self, from: savedProfile) {
                return loadedProfile
            }
        }
        return nil
    }

    func removeOwner() {
        userDefaults.removeObject(forKey: Keys.owner)
    }
}
