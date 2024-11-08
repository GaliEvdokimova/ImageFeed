//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 22.10.2024.
//
//получение базовой информации профиля

import UIKit

final class ProfileService {
    static let shared = ProfileService()
    private let builder: URLRequestBuilder
    private let urlSession = URLSession.shared
    private var currentTask: URLSessionTask?
    private(set) var profile: Profile?
    private var lastToken: String?
    private static let profileInfoUrl = Constants.defaultBaseURL + "/me"
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
//    enum AuthServiceError: Error {
//        case invalidRequest
//    }
    
//    struct ProfileResult: Codable {
//        let id: String
//        let username: String
//        let first_name: String
//        let last_name: String
//        let bio: String?
//    }
//    
//    struct Profile: Codable {
//        let username: String
//        let name: String
//        let loginName: String
//        let bio: String?
//        
//        init(from profileResult: ProfileResult) {
//            self.username = profileResult.username
//            self.name = profileResult.first_name + " " + profileResult.last_name
//            self.loginName = "@" + profileResult.username
//            self.bio = profileResult.bio
//        }
//    }
    
    func fetchProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeFetchProfileRequest() else {
            print("Invalid fetchProfile request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) {
            [weak self] (response: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch response {
                case .success(let profileResult):
                    let profile = Profile(profile: profileResult)
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.currentTask = task
        task.resume()
    }

private func makeFetchProfileRequest() -> URLRequest? {
    builder.makeHTTPRequest(
        path: "/me",
        httpMethod: "GET",
        defaultBaseURL: Constants.defaultBaseURL)
}
        }
