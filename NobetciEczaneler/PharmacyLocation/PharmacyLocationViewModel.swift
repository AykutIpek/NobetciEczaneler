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
    private let locationManager = CLLocationManager()
    @Published var region = MKCoordinateRegion()
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var directions: [MKRoute.Step] = []

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }

    func getDirections(to destination: CLLocationCoordinate2D) {
        guard let userLocation = userLocation else { return }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else { return }
            self.directions = response.routes.first?.steps ?? []
        }
    }
}

