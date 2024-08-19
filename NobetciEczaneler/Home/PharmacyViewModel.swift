//
//  PharmacyViewModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import Foundation

final class PharmacyViewModel: ObservableObject {
    @Published var pharmacies: [PharmacyModel] = []
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
    
    private func fetchPharmacies(district: String, province: String) async -> Result<[PharmacyModel], Error> {
        let endpoint = Endpoint.dutyPharmacy(district: district, province: province)
        let response: Result<PharmacyResponse, NetworkError> = await Service.request(endpoint: endpoint, responseType: PharmacyResponse.self)
        
        switch response {
        case .success(let pharmacyResponse):
            return .success(pharmacyResponse.result)
        case .failure(let error):
            return .failure(error)
        }
    }
}
