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
    static private var defaultBaseURL: URL {
        guard let url = URL(string: "https://api.unsplash.com") else {preconditionFailure("Unable to construct unsplashUrl")}
        return url
    }
    static var getTokenURL: URL {
        guard let url = URL(string: "https://unsplash.com/oauth/token") else {preconditionFailure("Unable to construct unsplashToken")}
        return url
    }
}
