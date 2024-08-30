//
//  LocationManager.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 30.08.2024.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        onLoad()
    }
    
    // Delegate method called when the authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
        
        // Check the authorization status
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.global(qos: .background).async {
                // Only request location if services are enabled
                if CLLocationManager.locationServicesEnabled() {
                    DispatchQueue.main.async {
                        self.requestLocation()
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Location services are disabled. Please enable them in Settings.")
                    }
                }
            }
        case .denied, .restricted:
            print("Location access denied/restricted.")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    // Method to request the user's location
    func requestLocation() {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    // Delegate method called when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            DispatchQueue.main.async {
                self.location = location
            }
            manager.stopUpdatingLocation()
        }
    }
    
    // Delegate method called when there is an error in obtaining the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    // Initial setup method
    private func onLoad() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
}

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}
