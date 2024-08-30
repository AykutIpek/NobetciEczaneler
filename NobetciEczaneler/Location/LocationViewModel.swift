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
    @Published var locationManager: LocationManager?
    @Published var pharmacies: [PharmacyModel] = []
    @Published var state: LocationViewState = .loading
    private var cancellables = Set<AnyCancellable>()
    
    init(locationManager: LocationManager? = LocationManager()) {
        self.locationManager = locationManager
        monitorAuthorizationStatus()
    }
    
    private func monitorAuthorizationStatus() {
        locationManager?.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                
                switch status {
                case .notDetermined:
                    self.locationManager?.requestLocation()
                case .restricted, .denied:
                    self.state = .error("Location access is restricted. Please enable it in Settings.")
                case .authorizedAlways, .authorizedWhenInUse:
                    self.loadUserLocationAndFetchPharmacies()
                default:
                    self.state = .error("Unexpected authorization status.")
                }
            }
            .store(in: &cancellables)
    }
    
    func loadUserLocationAndFetchPharmacies() {
        locationManager?.location?.placemark { [weak self] placemark, error in
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
                guard let self = self else { return }
                await self.loadPharmacies(district: district, province: province)
            }
        }
    }
    
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
    
    private func performRequestWithRetry<T>(request: @escaping () async -> Result<T, NetworkError>) async -> Result<T, NetworkError> {
        var attempt = 0
        
        while attempt < 3 {
            let result = await request()
            
            switch result {
            case .success:
                return result
            case .failure(let error):
                if case .serverError(let statusCode) = error, statusCode == 429 {
                    attempt += 1
                    try? await Task.sleep(nanoseconds: 1_000_000)
                } else {
                    return result
                }
            }
        }
        
        return .failure(.custom(errorMessage: "Request failed after 3 attempts."))
    }
    
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
