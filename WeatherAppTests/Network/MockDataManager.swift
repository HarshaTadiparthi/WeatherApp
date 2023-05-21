//
//  MockDataManager.swift
//  WeatherAppTests
//
//  Created by Harshavardhan Tadiparthi on 20/05/23.
//

import Foundation
import XCTest
@testable import WeatherApp

class MockDataManager<U: Codable>: APIService {
    
    //MARK: - Variables
    var handler: ((U?, NetworkError?) -> ())!
    var isDataFetched = false
    var model: U? = nil
    
    //MARK: - Success
    func fetchWithSuccess() {
        handler(model, nil)
    }
    
    //MARK: - Failure
    func fetchWithError(_ error: NetworkError?) {
        handler(nil, error)
    }
    
    //MARK: - API
    func fetchData<T: Codable>(with request: APIRequest,
                               handler: @escaping (_ data: T?, _ error: NetworkError?) -> ()) {
        isDataFetched = true
        self.handler = { (data: U?, error: NetworkError?) in
            handler(data as? T, error)
        }
    }
}
