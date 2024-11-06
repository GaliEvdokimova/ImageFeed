//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 29.10.2024.
//
//получение URL аватарки пользователя

import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    private let urlSession = URLSession.shared
    private var currentTask: URLSessionTask?
    private let builder: URLRequestBuilder
    private(set) var avatarURL: String?
    private var lastUserName: String?
    private let constants = Constants.defaultBaseURL
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchProfileImageURL(
        userName: String,
        _ completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        guard let request = makeProfileImageRequest(userName: userName) else {
            print("Invalid fetchProfileImageRequest request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self]
            (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let profilePhoto):
                    guard let profilePhoto = profilePhoto.profileImage?.small else { return }
                    self.avatarURL = profilePhoto
                    completion(.success(profilePhoto))
                    NotificationCenter.default
                        .post(
                            name: ProfileImageService.didChangeNotification,
                            object: self,
                            userInfo: ["URL": profilePhoto])
                case .failure(let error):
                    completion(.failure(error))
                    print("ProfileImageService Error: \(error)")
                }
                self.currentTask = nil
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    private func makeProfileImageRequest(userName: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/users/\(userName)",
            httpMethod: "GET",
            defaultBaseURL: constants)
    }
}

