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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack(alignment: .top) {
                    VStack(spacing: 16) {
                        pharmacyItems
                        Spacer()
                    }
                    .padding(.top, 120)
                    boxArea
                }
            }
            .disableBounces()
            .scrollIndicators(.hidden)
            .navigationTitle("Nöbetçi Eczaneler")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.container, edges: .bottom)
            .onLoad {
                viewModel.state = .onLoad
            }
        }
    }
    
    private var searchBar: some View {
        TextField("Eczane Ara", text: $viewModel.searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
    }
    
    private var boxArea: some View {
        VStack {
            searchBar
            HStack(alignment: .top) {
                province
                district
            }
            .padding(.horizontal, sizeClass == .compact ? 16 : 64)
        }
    }
    
    private var province: some View {
        DropdownView(
            title: "İl",
            prompt: "Seçiniz",
            options: Consts.turkishProvinces,
            selection: $viewModel.provinceSelected
        )
        .onChange(of: viewModel.provinceSelected) { newProvince in
            if let province = newProvince {
                let convertedProvince = viewModel.convertToEnglishCharacters(text: province)
                Task {
                    await viewModel.fetchDistricts(for: convertedProvince)
                    viewModel.districtSelected = nil
                    await viewModel.loadPharmacies(district: .empty, province: convertedProvince)
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
        .opacity(viewModel.districts.isEmpty ? 0.2 : 1)
        .onChange(of: viewModel.districtSelected) { newDistrict in
            Task {
                await viewModel.loadPharmacies(district: newDistrict.orEmptyString, province: viewModel.provinceSelected.orEmptyString)
            }
        }
    }
    
    @ViewBuilder
    private var pharmacyItems: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading...")
                .padding(.top, 200)
        case .error(let errorMessage):
            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.top, 150)
        case .loaded:
            ForEach(viewModel.filteredPharmacies, id: \.self) { pharmacy in
                PharmaciesCell(
                    viewModel: PharmaciesCellViewModel(
                        pharmacies: pharmacy.name.orEmptyString,
                        city: pharmacy.dist.orEmptyString,
                        phone: pharmacy.phone.orEmptyString,
                        location: pharmacy.address.orEmptyString
                    )
                )
                .padding(.horizontal, sizeClass == .compact ? .zero : 48)
            }
        case .loadedDistricts(let districts):
            if districts.isEmpty {
                Text("No districts available.")
                    .foregroundColor(.gray)
                    .padding()
            }
        case .onLoad:
            VStack(spacing: 16) {
                Image(systemName: "storefront.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.gray)
                
                Text("Bir Şehir Seçin")
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 150)
        }
    }
}


#Preview {
    PharmacyView()
}
