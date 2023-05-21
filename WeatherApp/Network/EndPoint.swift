//
//  EndPoint.swift
//  WeatherApp
//
//  Created by Harshavardhan Tadiparthi on 20/05/23.
//

import Foundation

/// `EndPoint` defines base URL, all paths and queries.
enum EndPoint: Hashable {
    //Base url
    case baseURL
    case appId
        
    //Today's forecast
    case todayForecast
    case latitude
    case longitude
    case query
}

extension EndPoint {
    var rawValue: String {
        switch self {
        //Base url
        case .baseURL:
            return "http://api.openweathermap.org/data/2.5/"
        case .appId:
            return "appid"
        
        //Today's forecast
        case .todayForecast:
            return "weather"
        case .latitude:
            return "lat"
        case .longitude:
            return "lon"
        case .query:
            return "q"
        }
    }
}
