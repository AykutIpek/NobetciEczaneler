//
//  PharmacyLocation.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 23.08.2024.
//

import SwiftUI
import MapKit

struct PharmacyLocationView: View {
    @StateObject private var viewModel = PharmacyLocationViewModel()
    
    // Static destination coordinates (example)
    let destination = CLLocationCoordinate2D(latitude: 39.88566860058295, longitude: 32.71559000015259)
    
    var body: some View {
        VStack {
           
        }
    }
}



#Preview {
    PharmacyLocationView()
}
