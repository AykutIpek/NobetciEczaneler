//
//  PharmacyView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

struct PharmacyView: View {
    @StateObject private var viewModel = PharmacyViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.pharmacies) { pharmacy in
                        VStack(alignment: .leading) {
                            Text(pharmacy.name ?? "")
                                .font(.headline)
                            Text(pharmacy.address ?? "")
                                .font(.subheadline)
                            Text(pharmacy.dist ?? "")
                                .font(.subheadline)
                            Text(pharmacy.phone ?? "")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Nöbetçi Eczaneler")
            .task {
                await viewModel.loadPharmacies(district: "seferihisar", province: "İzmir")
            }
        }
    }
}

#Preview {
    PharmacyView()
}
