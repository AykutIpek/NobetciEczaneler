//
//  PharmacyViewModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import Foundation
import SwiftUI

final class PharmacyViewModel: ObservableObject {
    @Published var pharmacies: [PharmacyModel] = []
    @Published var districts: [String] = []
    @Published var provinceSelected: String?
    @Published var districtSelected: String?
    @Published var state: PharmacyViewState = .loading
    private let retryLimit = 3
    private let retryDelay: UInt64 = 1_000_000_000
    
    @MainActor
    func loadPharmacies(district: String, province: String) async {
        state = .loading
        
        let result = await performRequestWithRetry { [weak self] in
            await self?.fetchPharmacies(district: district, province: province) ?? .failure(.custom(errorMessage: "Unexpected error"))
        }
        
        switch result {
        case .success(let pharmacies):
            self.pharmacies = pharmacies
            state = .loaded(pharmacies)
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }

    
    private func fetchPharmacies(district: String, province: String) async -> Result<[PharmacyModel], NetworkError> {
        let endpoint = Endpoint.dutyPharmacy(district: district, province: province)
        let response: Result<PharmacyResponse, NetworkError> = await Service.request(endpoint: endpoint, responseType: PharmacyResponse.self)
        
        switch response {
        case .success(let pharmacyResponse):
            return .success(pharmacyResponse.result)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    @MainActor
    func fetchDistricts(for province: String) async {
        state = .loading
        
        let result = await performRequestWithRetry { [weak self] in
            await self?.fetchDistrictsFromAPI(province: province) ?? .failure(.custom(errorMessage: "Unexpected error"))
        }
        
        switch result {
        case .success(let districts):
            self.districts = districts
            state = .loadedDistricts(districts)
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }

    
    private func fetchDistrictsFromAPI(province: String) async -> Result<[String], NetworkError> {
        let endpoint = Endpoint.districtList(province: province)
        let response: Result<DistrictResponse, NetworkError> = await Service.request(endpoint: endpoint, responseType: DistrictResponse.self)
        
        switch response {
        case .success(let districtResponse):
            if let result = districtResponse.result {
                let districtNames = result.compactMap { $0.text }
                return .success(districtNames)
            } else {
                return .failure(.custom(errorMessage: "District list is empty."))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    private func performRequestWithRetry<T>(request: @escaping () async -> Result<T, NetworkError>) async -> Result<T, NetworkError> {
        var attempt = 0
        
        while attempt < retryLimit {
            let result = await request()
            
            switch result {
            case .success:
                return result
            case .failure(let error):
                if case .serverError(let statusCode) = error, statusCode == 429 {
                    attempt += 1
                    try? await Task.sleep(nanoseconds: retryDelay)
                } else {
                    return result
                }
            }
        }
        
        return .failure(.custom(errorMessage: "Request failed after \(retryLimit) attempts."))
    }
}

