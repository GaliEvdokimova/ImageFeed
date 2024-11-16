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
    private let urlSession = URLSession.shared
    private var currentTask: URLSessionTask?
    private let builder: URLRequestBuilder
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard currentTask == nil else { return }
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        
        guard let request = makeImagesListRequest(page: nextPage) else {
            print("Invalid fetchPhotos request")
            return
        }
        let task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<[PhotoResult], Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let photoResult):
                    let photos = photoResult.map { Photo(result: $0) }
                    self.photos.append(contentsOf: photos)
                    self.lastLoadedPage = nextPage
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: nil)
                case .failure(let error):
                    print(error)
                }
                self.currentTask = nil
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    private func makeImagesListRequest(page: Int) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/photos"
            + "?page=\(page)"
            + "&&per_page=10",
            httpMethod: "GET",
            defaultBaseURL: Constants.defaultBaseURL)
    }
    private func makeLikeRequest(photoID: String, isLike: Bool) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/photos/\(photoID)/like",
            httpMethod: isLike ? "POST" : "DELETE",
            defaultBaseURL: Constants.defaultBaseURL)
    }
}
