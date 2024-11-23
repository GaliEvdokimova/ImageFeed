//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 30.08.2024.
//

import UIKit
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private init() { }
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            return keychainWrapper.string(forKey: "token")
        }
        set {
            guard let newValue else { return }
            keychainWrapper.set(newValue, forKey: "token")
        }
    }
    
    func clearToken() {
        KeychainWrapper.standard.removeObject(forKey: "token")
    }
}
