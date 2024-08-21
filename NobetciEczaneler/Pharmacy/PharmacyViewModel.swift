//
//  PharmacyViewModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import Foundation

final class PharmacyViewModel: ObservableObject {
    @Published var pharmacies: [PharmacyModel] = []
    @Published var districts: [String] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    @MainActor
    func loadPharmacies(district: String, province: String) async {
        isLoading = true
        errorMessage = nil
        
        let result = await fetchPharmacies(district: district, province: province)
        
        isLoading = false
        switch result {
        case .success(let pharmacies):
            self.pharmacies = pharmacies
        case .failure(let error):
            self.errorMessage = error.localizedDescription
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
    
    // Load districts based on the selected province
    @MainActor
    func fetchDistricts(for province: String) async {
        isLoading = true
        errorMessage = nil
        
        let result = await fetchDistrictsFromAPI(province: province)
        
        isLoading = false
        switch result {
        case .success(let districts):
            self.districts = districts
        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }
    
    // Fetch districts from the API
    private func fetchDistrictsFromAPI(province: String) async -> Result<[String], NetworkError> {
        let endpoint = Endpoint.districtList(province: province)
        let response: Result<DistrictResponse, NetworkError> = await Service.request(endpoint: endpoint, responseType: DistrictResponse.self)
        
        switch response {
        case .success(let districtResponse):
            // Safely unwrap optional values and return the district names
            if let result = districtResponse.result {
                let districtNames = result.compactMap { $0.text }
                return .success(districtNames)
            } else {
                // Handle the case where 'result' is nil
                return .failure(.custom(errorMessage: "District list is empty."))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
