//
//  APIManager.swift
//  WeatherApp
//
//  Created by Harshavardhan Tadiparthi on 20/05/23.
//

import Foundation

/// `APIManager` is an abstract type, used to parse the `Result` data from the server.
struct APIManager {}

protocol APIService {
    func fetchData<T: Codable>(with request: APIRequest,
                               handler: @escaping (_ data: T?, _ error: NetworkError?) -> ())
}

extension APIManager: APIService {
    
    /// It is an abstract method, send the request to `APIClient` and handles the response received from it.
    /// - Parameters:
    ///   - request: A request to be passed to server.
    ///   - handler: A closure which holds data and error which is received from server.
    ///   - data: A model data of type `T`, which is received from API.
    ///   - error: An error received from service call.
    func fetchData<T: Codable>(with request: APIRequest,
                               handler: @escaping (_ data: T?, _ error: NetworkError?) -> ()) {
        APIClient.send(request) { (result: Result<T, NetworkError>) in
            switch result {
            case .success(let data):
                handler(data, nil)
            case .failure(let failError):
                handler(nil, failError)
            }
        }
    }
}
