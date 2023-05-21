//
//  APIRequestTests.swift
//  WeatherAppTests
//
//  Created by Harshavardhan Tadiparthi on 20/05/23.
//

import XCTest
@testable import WeatherApp

class APIRequestTests: XCTestCase {

    //MARK: - Variables
    var sut: APIRequest!
    
    //MARK: - Setup
    override func setUp() {
        super.setUp()
        sut = MockRequest()
    }
    
    //MARK: - Tests
    func testSuccessfulRequest() {
        let request = sut.request()
        XCTAssertNotNil(request.httpMethod, "HTTP Method should be there.")
        XCTAssertEqual(request.httpMethod, HTTPMethod.GET.rawValue, "HTTP Methods should be same.")
        XCTAssertNotNil(request.url, "URL should be there.")
        XCTAssertEqual(request.url?.absoluteString, "http://api.openweathermap.org/data/2.5/weather?appid=bf9e46d75347340ba0fc53f8b0050a73", "URL should be there.")
        XCTAssertNil(request.httpBody, "There is no body for the request.")
        XCTAssertNotNil(request.allHTTPHeaderFields, "Header Fields should be there.")
    }
    
    func testFailureRequest() {
        let request = sut.request()
        XCTAssertNotEqual(request.httpMethod, "empty","HTTP Method shouldn't be empty.")
        XCTAssertNotEqual(request.url?.absoluteString, "empty", "URL shouldn't be empty.")
        XCTAssertNotEqual(request.httpBody, Data(), "Data should be empty")
        XCTAssertNotEqual(request.allHTTPHeaderFields, [:], "Header Fields should not be empty.")
    }
    
    //MARK: - Teardown
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
}

struct MockRequest: APIRequest {
    var method: HTTPMethod = .GET
    var path: EndPoint = .todayForecast
    var parameters: [EndPoint : String] = [:]
    var body: [String : Any]? = nil
}

struct Model: Codable {}
