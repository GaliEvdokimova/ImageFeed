//
//  Untitled.swift
//  ImageFeed
//
//  Created by Galina evdokimova on 03.10.2024.
//

import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
    case decodingError(Error)
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let fulfillCompletion: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
                if let data,
                    let response,
                    let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200 ..< 300 ~= statusCode {
                        do {
                            let decoder = JSONDecoder()
                            let result = try decoder.decode(T.self, from: data)
                            fulfillCompletion(.success(result))
                        } catch {
                            fulfillCompletion(.failure(NetworkError.decodingError(error)))
                        }
                    } else {
                        fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                        print("Invalid get access token response: \(statusCode)")
                    }
                } else if let error {
                    fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
                    print("Request error: \(error)")
                } else {
                    fulfillCompletion(.failure(NetworkError.urlSessionError))
                    print("Session error")
                }
            })
        task.resume()
        return task
    }
}
