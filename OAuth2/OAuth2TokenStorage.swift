//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 30.08.2024.
//

import UIKit

final class OAuth2TokenStorage {
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get { userDefaults.string(forKey: "token") }
        set { userDefaults.set(newValue, forKey: "token") }
    }
}
