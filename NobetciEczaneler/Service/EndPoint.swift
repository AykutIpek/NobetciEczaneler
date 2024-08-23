//
//  EndPoint.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import Foundation

enum Endpoint {
    case dutyPharmacy(district: String, province: String)
    case districtList(province: String)
    
    var baseURL: String {
        return "https://api.collectapi.com/health/"
    }
    
    var path: String {
        switch self {
        case .dutyPharmacy:
            return "dutyPharmacy"
        case .districtList:
            return "districtList"
        }
    }
    
    var urlString: String {
        return baseURL + path
    }
    
    var headers: [String: String] {
        return [
            "content-type": "application/json",
            "authorization": "apikey 26iibd4BXNoKLyxJMOlvFk:48UXBLXu9GWsjvVX9H2YTH"
        ]
    }
    
    func urlRequest() -> URLRequest? {
        guard var urlComponents = URLComponents(string: urlString) else { return nil }
        
        switch self {
        case .dutyPharmacy(let district, let province):
            urlComponents.queryItems = [
                URLQueryItem(name: "ilce", value: district),
                URLQueryItem(name: "il", value: province)
            ]
        case .districtList(let province):
            urlComponents.queryItems = [
                URLQueryItem(name: "il", value: province)
            ]
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
