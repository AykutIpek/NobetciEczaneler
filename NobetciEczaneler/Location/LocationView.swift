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
                        .scaleEffect(1.5)
                case .error(let error):
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        if error.contains("restricted") || error.contains("disabled") {
                            Button(action: {
                                openSettings()
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
            .navigationTitle("Nearby Pharmacies")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}


struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var selectedPharmacy: PharmacyModel?
    
    let pharmacies: [PharmacyModel]
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9334, longitude: 32.8597), // Başlangıçta Ankara koordinatları, kullanıcı konumu alındığında değiştirilecek
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
                // Kullanıcının mevcut konumunu başlangıç noktası olarak ayarlayın
                region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            }
        }
        .onChange(of: locationManager.location) { newLocation in
            guard let newLocation = newLocation else { return }
            // Konum güncellendiğinde haritada göster
            region = MKCoordinateRegion(
                center: newLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
        .sheet(item: $selectedPharmacy) { pharmacy in
            VStack {
                Text(pharmacy.name ?? "Unknown Pharmacy")
                    .font(.title)
                    .padding()
                
                Button(action: {
                    openInAppleMaps(destination: pharmacy.locationCoordinate)
                }) {
                    Text("Get Directions")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private func openInAppleMaps(destination: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: destination)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = selectedPharmacy?.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

#Preview {
    LocationView()
}
