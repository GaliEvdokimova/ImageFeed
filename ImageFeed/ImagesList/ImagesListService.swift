//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 16.11.2024.
//

import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
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
        let nextPage = (lastLoadedPage ?? 0) + 1
        
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
                    print(error.localizedDescription)
                }
                self.currentTask = nil
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    func changeLike(photoId: String,
                    isLike: Bool,
                    _ completion: @escaping (Result<Void, Error>) -> Void
    ) { assert(Thread.isMainThread)
        guard let request = makeLikeRequest(photoID: photoId, isLike: isLike) else {
            print("Invalid like")
            return
        }
        let task = urlSession.objectTask(for: request) {
            [weak self] (result: Result<LikeResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             isLiked: !photo.isLiked
                        )
                        self.photos[index] = newPhoto
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                    print(error.localizedDescription)
                }
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
