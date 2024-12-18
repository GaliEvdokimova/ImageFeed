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
