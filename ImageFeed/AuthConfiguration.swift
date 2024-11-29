//
//  Constants.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 11.08.2024.
//

import UIKit

enum Constants {
    static let accessKey = "24SXpvG8Unz8TltKZZYwfkPrh2Y1yBftK_jcmCkQlU4"
    static let secretKey = "kX6lwVWvg78NFwd_KTvviD74h_Sy2rM3TXzJfrKIEFQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURLString = "https://unsplash.com"
    static var defaultBaseURL = "https://api.unsplash.com"
    static let baseAuthTokenPath = "/oauth/token"
    static let authorizedPath = "/oauth/authorize/native"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static var getTokenURL = "https://unsplash.com/oauth/token"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURLString: String
    var defaultBaseURL: String
    let baseAuthTokenPath: String
    let authorizedPath: String
    let unsplashAuthorizeURLString: String
    var getTokenURL: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURLString: String, defaultBaseURL: String, baseAuthTokenPath: String, authorizedPath: String, unsplashAuthorizeURLString: String, getTokenURL: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURLString = defaultBaseURLString
        self.defaultBaseURL = defaultBaseURL
        self.baseAuthTokenPath = baseAuthTokenPath
        self.authorizedPath = authorizedPath
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.getTokenURL = getTokenURL
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURLString: Constants.defaultBaseURLString,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 baseAuthTokenPath: Constants.baseAuthTokenPath,
                                 authorizedPath: Constants.authorizedPath,
                                 unsplashAuthorizeURLString: Constants.unsplashAuthorizeURLString,
                                 getTokenURL: Constants.getTokenURL)
    }
}
