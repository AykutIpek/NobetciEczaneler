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
                    MapView(pharmacies: pharmacies, userLocation: viewModel.locationManager?.location)
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
    let pharmacies: [PharmacyModel]
    let userLocation: CLLocation?
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.9334, longitude: 32.8597), // Default to Ankara
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: pharmacies) { pharmacy in
            MapAnnotation(coordinate: pharmacy.locationCoordinate) {
                VStack {
                    Image(systemName: "cross.circle.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                    Text(pharmacy.name ?? "Unknown")
                        .font(.caption)
                        .padding(5)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(8)
                }
            }
        }
        .onAppear {
            if let location = userLocation {
                region.center = location.coordinate
            }
        }
    }
}

#Preview {
    LocationView()
}
