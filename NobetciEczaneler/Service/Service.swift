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
//    static func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async -> ServiceResponse<T> {
//        guard let request = endpoint.urlRequest() else {
//            return ServiceResponse(data: nil, response: nil, error: NSError(domain: "Invalid URL", code: -1, userInfo: nil))
//        }
//        
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            let decodedData = try JSONDecoder().decode(T.self, from: data)
//            return ServiceResponse(data: decodedData, response: response, error: nil)
//        } catch {
//            return ServiceResponse(data: nil, response: nil, error: error)
//        }
//    }
    
    static func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async -> Result<T, NetworkError> {
        guard let request = endpoint.urlRequest() else {
            return .failure(.invalidURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                return .failure(.serverError(statusCode: httpResponse.statusCode))
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                return .success(decodedData)
            } catch {
                return .failure(.decodingFailed)
            }
        } catch {
            return .failure(.custom(errorMessage: error.localizedDescription))
        }
    }
}
