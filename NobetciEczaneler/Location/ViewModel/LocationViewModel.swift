//
//  LocationViewModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 29.08.2024.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import CoreLocation

enum LocationViewState: Equatable {
    case loading
    case error(String)
    case loaded([PharmacyModel])
}

final class LocationViewModel: ObservableObject {
    @Published var pharmacies: [PharmacyModel] = []
    @Published var state: LocationViewState = .loading
    private var cancellables = Set<AnyCancellable>()
    private let locationManager: LocationManager
    
    init(locationManager: LocationManager = LocationManager()) {
        self.locationManager = locationManager
        monitorAuthorizationStatus()
    }
    
    private func monitorAuthorizationStatus() {
        locationManager.$location
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self = self, let location = location else {
                    self?.state = .error("Location services are disabled or restricted. Please enable them in Settings.")
                    return
                }
                self.loadUserLocationAndFetchPharmacies(location: location)
            }
            .store(in: &cancellables)
    }
    
    private func loadUserLocationAndFetchPharmacies(location: CLLocation) {
        location.placemark { [weak self] placemark, error in
            guard let self = self else { return }
            
            if let error = error {
                self.state = .error("Failed to get location: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemark else {
                self.state = .error("Failed to determine your location.")
                return
            }
            
            let district = placemark.locality ?? ""
            let province = placemark.administrativeArea ?? "İzmir"
            
            Task { [weak self] in
                await self?.loadPharmacies(district: district, province: province)
            }
        }
    }
    
    @MainActor
    private func loadPharmacies(district: String, province: String) async {
        state = .loading
        let result = await fetchPharmacies(district: district, province: province)
        
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
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
