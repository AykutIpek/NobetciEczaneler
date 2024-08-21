//
//  PharmacyView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

struct PharmacyView: View {
    @StateObject private var viewModel = PharmacyViewModel()
    @Environment(\.horizontalSizeClass) var sizeClass
//    let columns = [GridItem(.adaptive(minimum: 300))]
//    let columns = [GridItem(.fixed(200))]
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 24) {
                    boxArea
                    pharmacyItems
                    Spacer()
                }
                .navigationTitle("Nöbetçi Eczaneler")
            }
        }
    }
    
    private var boxArea: some View {
        HStack(alignment: .top) {
            province
            district
        }
        .padding(.horizontal)
    }
    
    private var province: some View {
        DropdownView(
            title: "İl",
            prompt: "Seçiniz",
            options: Consts.turkishProvinces,
            selection: $viewModel.provinceSelected
        )
        .onChange(of: viewModel.provinceSelected) { _, newProvince in
            if let province = newProvince {
                Task {
                    await viewModel.fetchDistricts(for: province)
                    viewModel.districtSelected = nil
                    await viewModel.loadPharmacies(district: "", province: province)
                }
            }
        }
    }
    
    private var district: some View {
        DropdownView(
            title: "İlçe",
            prompt: "Seçiniz",
            options: viewModel.districts,
            selection: $viewModel.districtSelected
        )
        .disabled(viewModel.districts.isEmpty)
        .onChange(of: viewModel.districtSelected) { _, newDistrict in
            Task {
                await viewModel.loadPharmacies(district: newDistrict ?? "", province: viewModel.provinceSelected ?? "")
            }
        }
    }
    
    @ViewBuilder
    private var pharmacyItems: some View {
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
}

#Preview {
    PharmacyView()
}
