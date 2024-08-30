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
        NavigationStack {
            switch viewModel.state {
            case .loading:
                ProgressView("Loading pharmacies...")
            case .error(let error):
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
            case .loaded( _):
                content
            }
        }
    }
    
    private var content: some View {
        VStack {
            if let location = viewModel.locationManager?.location {
                Text("Location: \(location.coordinate.latitude)")
                Text("Location: \(location.coordinate.longitude)")
            }
        }
    }
}

#Preview {
    LocationView()
}
