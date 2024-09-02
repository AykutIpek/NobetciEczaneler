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
    @Published var pinCoordinate: CLLocationCoordinate2D?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion
    @Published var selectedPharmacy: PharmacyModel?
    @Published var pinTapped: Bool = false
    
    private let locationManager = CLLocationManager()
    
    init(pharmacy: PharmacyModel?) {
        self.selectedPharmacy = pharmacy
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.0, longitude: 35.0),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        super.init()
        onLoad()
    }
    
    var mapAnnotationItems: [IdentifiableCoordinate] {
        guard let coordinate = pinCoordinate else { return [] }
        return [IdentifiableCoordinate(coordinate: coordinate)]
    }
    
    func openInAppleMaps() {
        guard let destination = pinCoordinate else { return }
        let placemark = MKPlacemark(coordinate: destination)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = selectedPharmacy?.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    func areCoordinatesEqual(_ lhs: CLLocationCoordinate2D, _ rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location.coordinate
            locationManager.stopUpdatingLocation()
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
    
    private func onLoad() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        setPinCoordinate(from: selectedPharmacy?.loc)
    }
    
    private func setPinCoordinate(from location: String?) {
        guard let location = location else { return }
        let components = location.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard components.count == 2 else { return }
        let coordinate = CLLocationCoordinate2D(latitude: components[0], longitude: components[1])
        pinCoordinate = coordinate
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }
}
