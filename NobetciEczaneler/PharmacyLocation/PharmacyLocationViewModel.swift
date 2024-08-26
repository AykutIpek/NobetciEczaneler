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
    //MARK: - Published
    @Published var pinCoordinate: CLLocationCoordinate2D?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var route: MKRoute?
    @Published var region: MKCoordinateRegion
    @Published var selectedPharmacy: PharmacyModel?
    @Published var pinTapped: Bool = false
    //MARK: - Model
    @Published var pharmacyName: String?
    @Published var pharmacyAddress: String?
    @Published var pharmacyDist: String?
    @Published var pharmacyLoc: String?
    @Published var pharmacyPhone: String?
    //MARK: - Private Helpers
    private let locationManager = CLLocationManager()
    
    
    init(_ model: PharmacyModel?) {
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.0, longitude: 35.0),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        super.init()
        selectedPharmacyModel(model)
        onLoad()
    }
    
    private func onLoad() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setPinCoordinate(from: pharmacyLoc)
    }
    
    private func selectedPharmacyModel(_ model: PharmacyModel?) {
        selectedPharmacy = model
        pharmacyName = model?.name.orEmptyString
        pharmacyAddress = model?.address.orEmptyString
        pharmacyDist = model?.dist.orEmptyString
        pharmacyLoc = model?.loc.orEmptyString
        pharmacyPhone = model?.phone.orEmptyString
    }

    private func setPinCoordinate(from location: String?) {
        let components = location.orEmptyString
            .split(separator: ",")
            .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        
        if components.count == 2 {
            let coordinate = CLLocationCoordinate2D(latitude: components[0], longitude: components[1])
            pinCoordinate = coordinate
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    }
    
    private func updateRegion(for route: MKRoute) {
        let mapRect = route.polyline.boundingMapRect
        let region = MKCoordinateRegion(mapRect)
        self.region = region
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location.coordinate
            locationManager.stopUpdatingLocation()
        }
    }

    func getDirections() {
        guard let userLocation = userLocation, let destination = pinCoordinate else {
            print("Error: Missing location data.")
            return
        }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                return
            }
            guard let route = response?.routes.first else {
                print("No route found.")
                return
            }
            DispatchQueue.main.async {
                self?.route = route
                self?.updateRegion(for: route)
            }
        }
    }

    func setupInitialRegion() {
        if let pinCoordinate = pinCoordinate {
            region = MKCoordinateRegion(
                center: pinCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    }

    func selectPharmacy() {
        self.pinTapped = true
    }

    func deselectPharmacy() {
        self.selectedPharmacy = nil
        self.pinTapped = false
    }
}
