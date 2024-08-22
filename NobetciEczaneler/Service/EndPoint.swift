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
    
    /// apikey 12MpJ9zGxA86s7qlDEq8u7:2FWJ7bjDFzNhrxDhLsjQqX
    var headers: [String: String] {
        return [
            "content-type": "application/json",
            "authorization": "apikey 0ERDWsYb4cWNpNFnm4t0LS:2AfyYohdO1ZGT0y0AMVfTo"
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
