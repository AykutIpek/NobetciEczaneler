//
//  LocationViewModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 29.08.2024.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

enum LocationViewState: Equatable {
    case loading
    case error(String)
    case loaded([PharmacyModel])
}

final class LocationViewModel: ObservableObject {
    @Published var locationManager: LocationManager?
    @Published var pharmacyModel: PharmacyModel?
    @Published var pharmacies: [PharmacyModel] = []
    @Published var state: LocationViewState = .loading
    
    init(locationManager: LocationManager? = LocationManager()) {
        self.locationManager = locationManager
        onLoad()
    }
    
    private func onLoad() {
        locationManager?.requestLocation()
        Task {
            await loadPharmacies(district: "", province: "İzmir")
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
}


final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        onLoad()
    }
    
    func onLoad() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        requestLocation()
    }
    
    func requestLocation() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
