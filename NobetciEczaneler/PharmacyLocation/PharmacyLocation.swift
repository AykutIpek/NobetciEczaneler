//
//  PharmacyLocation.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 23.08.2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}


struct PharmacyLocationView: View {
    @StateObject var viewModel: PharmacyLocationViewModel

    var body: some View {
        Map(
            coordinateRegion: $viewModel.region,
            showsUserLocation: true,
            annotationItems: [viewModel.pinCoordinate].compactMap { coordinate in
                guard let coordinate = coordinate else { return nil }
                return IdentifiableCoordinate(coordinate: coordinate)
            }
        ) { (coordinateWrapper: IdentifiableCoordinate) in
            MapAnnotation(coordinate: coordinateWrapper.coordinate) {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: viewModel.pinTapped ? 60 : 40, height: viewModel.pinTapped ? 60 : 40)
                    .foregroundColor(.red)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            viewModel.pinTapped.toggle()
                        }
                        viewModel.getDirections()
                    }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .overlay(alignment: .bottom) {
            if let route = viewModel.route {
                VStack {
                    Text("Route to Pharmacy")
                        .font(.headline)
                    MapRouteView(route: route)
                        .frame(height: 200)
                }
                .background(Color.white.opacity(0.8))
                .cornerRadius(12)
                .padding()
            }
        }
    }
}

#Preview {
    PharmacyLocationView(viewModel: PharmacyLocationViewModel(location: "39.886647,32.698172"))
}
