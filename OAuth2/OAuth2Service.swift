//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 22.08.2024.
//

import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private var storage: OAuth2TokenStorage
    private var urlSession: URLSession
    private var currentTask: URLSessionTask?
    private var lastCode: String?
    private let builder: URLRequestBuilder
    
    init(
        storage: OAuth2TokenStorage = .shared,
        urlSession: URLSession = .shared,
        builder: URLRequestBuilder = .shared
    ) {
        self.storage = storage
        self.urlSession = urlSession
        self.builder = builder
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        guard code != lastCode else { return }
        currentTask = nil
        guard let request = makeTokenRequest(code: code) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        let task = urlSession.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch response {
                case .success(let body):
                    let authToken = body.accessToken
                    self.storage.token = authToken
                    completion(.success(authToken))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    
    // MARK: - Private Methods
    private func makeTokenRequest(code: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "\(Constants.baseAuthTokenPath)"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            defaultBaseURL: Constants.defaultBaseURLString
        )
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}
