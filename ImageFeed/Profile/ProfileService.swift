//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 22.10.2024.
//
//получение базовой информации профиля

import UIKit
import WebKit

final class ProfileService {
    static let shared = ProfileService()
    private let builder: URLRequestBuilder
    private let urlSession = URLSession.shared
    private var currentTask: URLSessionTask?
    private(set) var profile: Profile?
    private var lastToken: String?
    private let storage: OAuth2TokenStorage
    private static let profileInfoUrl = Constants.defaultBaseURL + "/me"
    
    init(builder: URLRequestBuilder = .shared,
         storage: OAuth2TokenStorage = .shared) {
        self.builder = builder
        self.storage = storage
    }
    
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
                    print("ProfileService Error: \(error)")
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    func logout() {
        ProfileService.cleanCookies()
        storage.clearToken()
    }
    
    static func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func makeFetchProfileRequest() -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            defaultBaseURL: Constants.defaultBaseURL)
    }
}
