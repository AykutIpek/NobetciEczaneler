//
//  HomeView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
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
                            Text(pharmacy.phone ?? "")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Nöbetçi Eczaneler")
            .task {
                await viewModel.loadPharmacies()
            }
        }
    }
}

#Preview {
    HomeView()
}
