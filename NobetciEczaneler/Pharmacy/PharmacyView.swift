//
//  PharmacyView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

struct PharmacyView: View {
    @StateObject private var viewModel = PharmacyViewModel()
    @State private var provinceSelected: String?
    @State private var districtSelected: String?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                DropdownView(
                    title: "İl",
                    prompt: "Seçiniz",
                    options: Consts.turkishProvinces,
                    selection: $provinceSelected
                )
                .onChange(of: provinceSelected) { _, newProvince in
                    if let province = newProvince {
                        Task {
                            await viewModel.fetchDistricts(for: province)
                            districtSelected = nil
                        }
                    }
                }
                
                DropdownView(
                    title: "İlçe",
                    prompt: "Seçiniz",
                    options: viewModel.districts,
                    selection: $districtSelected
                )
                .disabled(viewModel.districts.isEmpty)
                .onChange(of: districtSelected) { _,_ in
                    Task {
                        await viewModel.loadPharmacies(district: districtSelected ?? "", province: provinceSelected ?? "")
                    }
                }
                
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
                Spacer()
            }
            .navigationTitle("Nöbetçi Eczaneler")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PharmacyView()
}
