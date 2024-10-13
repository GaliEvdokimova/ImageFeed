//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 22.08.2024.
//

import UIKit

final class OAuth2Service {
    private var tokenStorage = OAuth2TokenStorage()
    static let shared = OAuth2Service()
    private init() {}
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, any Error>) -> Void) {
        
        guard let request = makeTokenRequest(code: code) else { return }
        
        let task = urlSession.data(for: request) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success(let data):
                
                do {
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                    print("Successfully received token: \(responseBody.accessToken)")
                } catch {
                    completion(.failure(error))
                    print("Decoding error: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                completion(.failure(error))
                print("Error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    
    // MARK: - Private Methods
    private func makeTokenRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: Constants.getTokenURL.absoluteString)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents?.url else {
            print("Failed to create URL from components")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        print("Token request created: \(request)")
        
        return request
        
    }
    
}
