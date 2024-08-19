//
//  Service.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import Foundation

struct ServiceResponse<T: Decodable> {
    let data: T?
    let response: URLResponse?
    let error: Error?
}

final class Service {
    static func request<T: Decodable>(urlString: String, headers: [String: String], responseType: T.Type) async -> ServiceResponse<T> {
        guard let url = URL(string: urlString) else {
            return ServiceResponse(data: nil, response: nil, error: NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let jsonString = String(data: data, encoding: .utf8)
            print("Received JSON: \(jsonString ?? "No Data")")
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return ServiceResponse(data: decodedData, response: response, error: nil)
        } catch {
            print("Decoding error: \(error.localizedDescription)")
            return ServiceResponse(data: nil, response: nil, error: error)
        }
    }
}
