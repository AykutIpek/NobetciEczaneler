//
//  PharmacyLocationViewModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 23.08.2024.
//

import SwiftUI
import CoreLocation
import MapKit

final class PharmacyLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var pinCoordinate: CLLocationCoordinate2D? // Keep this as CLLocationCoordinate2D?
    @Published var userLocation: CLLocationCoordinate2D? // Assume this is being set elsewhere
    @Published var route: MKRoute?
    @Published var pinTapped: Bool = false
    @Published var region: MKCoordinateRegion = MKCoordinateRegion() // Initial region

    private let locationManager = CLLocationManager()
    
    init(location: String) {
        // Default region centered on Turkey
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.0, longitude: 35.0),
                                         span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        super.init()
        locationManager.delegate = self
        parseLocation(location)
        requestLocation()
    }

    private func parseLocation(_ location: String) {
        let components = location
            .split(separator: ",")
            .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        
        if components.count == 2 {
            let coordinate = CLLocationCoordinate2D(latitude: components[0], longitude: components[1])
            pinCoordinate = coordinate // Assigning CLLocationCoordinate2D directly
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }

    private func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location.coordinate
            locationManager.stopUpdatingLocation() // Stop after getting the current location
        }
    }

    func getDirections() {
        guard let userLocation = userLocation, let destination = pinCoordinate else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let route = response?.routes.first else { return }
            self?.route = route
        }
    }
}

