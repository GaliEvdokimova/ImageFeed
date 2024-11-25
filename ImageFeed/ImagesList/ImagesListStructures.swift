//
//  ImagesListStructures.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 16.11.2024.
//

import UIKit

extension String {
    private static let formatterDateISO = ISO8601DateFormatter()
    
    func convertStringToDateFormat() -> Date? {
        let date = String.formatterDateISO.date(from: self)
        return date
    }
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

extension Photo {
    init(result: PhotoResult) {
        self.init(
            id: result.id,
            size: CGSize(width: result.width, height: result.height),
            createdAt: result.createdAt?.convertStringToDateFormat(),
            welcomeDescription: result.description ?? "",
            thumbImageURL: result.urls.thumb ?? "",
            largeImageURL: result.urls.full ?? "",
            isLiked: result.likedByUser)
    }
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let blurHash: String?
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let user: ProfileResult
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case blurHash
        case likes
        case likedByUser = "liked_by_user"
        case description
        case user
        case urls
    }
}

struct UrlsResult: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
}

struct LikeResult: Decodable {
    let photo: PhotoResult
}
