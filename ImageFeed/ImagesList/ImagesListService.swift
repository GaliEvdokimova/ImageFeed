//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 16.11.2024.
//

import UIKit

final class ImagesListService {
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotosNextPage() {
        let nextPage = (lastLoadedPage?.number ?? 0) + 1
    }
}
