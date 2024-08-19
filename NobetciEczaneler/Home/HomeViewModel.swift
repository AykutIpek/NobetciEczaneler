//
//  HomeViewModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import Foundation

final class HomeViewModel: ObservableObject {
    @Published var pharmacies: [PharmacyModel] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    func fetchPharmacies() async -> Result<[PharmacyModel], Error> {
        let headers = [
            "content-type": "application/json",
            "authorization": "apikey 12MpJ9zGxA86s7qlDEq8u7:2FWJ7bjDFzNhrxDhLsjQqX"
        ]
        
        let urlString = "https://api.collectapi.com/health/dutyPharmacy?ilce=%C3%87ankaya&il=Ankara"
        
        let response: ServiceResponse<PharmacyResponse> = await Service.request(urlString: urlString, headers: headers, responseType: PharmacyResponse.self)
        
        if let error = response.error {
            return .failure(error)
        } else if let fetchedPharmacies = response.data?.result {
            return .success(fetchedPharmacies)
        } else {
            return .failure(NSError(domain: "Unknown error", code: -1, userInfo: nil))
        }
    }
    
    @MainActor
    func loadPharmacies() async {
        isLoading = true
        errorMessage = nil
        
        let result = await fetchPharmacies()
        
        isLoading = false
        switch result {
        case .success(let pharmacies):
            self.pharmacies = pharmacies
        case .failure(let error):
            self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
        }
    }
}
