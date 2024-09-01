//
//  LocationView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 20.08.2024.
//

import SwiftUI
import MapKit
import CoreLocation


struct LocationView: View {
    @StateObject private var viewModel = LocationViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.state {
                case .loading:
                    ProgressView("Loading...")
                case .error(let error):
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        if error.contains("restricted") || error.contains("disabled") {
                            Button(action: {
                                viewModel.openSettings()
                            }) {
                                Text("Open Settings")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                case .loaded(let pharmacies):
                    MapView(pharmacies: pharmacies)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
}


struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedPharmacy: PharmacyModel?
    @State private var isBottomSheetPresented: Bool = false
    
    let pharmacies: [PharmacyModel]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.925533, longitude: 32.836991),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: pharmacies) { pharmacy in
            MapAnnotation(coordinate: pharmacy.locationCoordinate) {
                Button(action: {
                    selectedPharmacy = pharmacy
                }) {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            if let location = locationManager.location {
                region.center = location.coordinate
            }
        }
        .onChange(of: locationManager.location) { newLocation in
            if let newLocation = newLocation {
                region = MKCoordinateRegion(
                    center: newLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        }
        .onChange(of: selectedPharmacy) { _ in
            if selectedPharmacy != nil {
                isBottomSheetPresented = true
            }
        }
        .sheet(isPresented: $isBottomSheetPresented, onDismiss: didDismissAction) {
            if let pharmacy = selectedPharmacy {
                BottomSheetView(
                    pharmacy: pharmacy,
                    onDismiss: {
                        didDismissAction()
                    },
                    onGetDirections: {
                        openInAppleMaps()
                        isBottomSheetPresented = false
                    }
                )
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.4)])
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func openInAppleMaps() {
        guard let destination = selectedPharmacy?.locationCoordinate else { return }
        let placemark = MKPlacemark(coordinate: destination)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = selectedPharmacy?.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    private func didDismissAction() {
        isBottomSheetPresented = false
        selectedPharmacy = nil
    }
}

#Preview {
    LocationView()
}
