//
//  CityChangeView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

struct CityChangeView: View {
    @StateObject private var viewModel = CityChangeViewModel()
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        GeometryReader { _ in
            NavigationStack {
                VStack(spacing: 16) {
                    boxArea
                    pharmacyItems
                    Spacer()
                }
                .padding(.horizontal)
                .navigationTitle(LocalizableString.pharmaciesTitle.rawValue.localized)
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea(.container, edges: .bottom)
                .onLoad {
                    viewModel.state = .onLoad
                }
                .hideKeyboardOnTap()
            }
        }
    }
    
    private var boxArea: some View {
        VStack {
            if viewModel.provinceSelected != nil {
                Group {
                    searchBar
                    searchCityBar
                }
                .transition(.opacity)
            }
            HStack(alignment: .top, spacing: 16) {
                province
                district
            }
        }
        .animation(.easeInOut, value: viewModel.provinceSelected)
    }
    
    private var searchBar: some View {
        TextField(LocalizableString.searchPharmarcies.rawValue.localized, text: $viewModel.searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardToolbar()
            .disabled(viewModel.state == .loading)
            .opacity(viewModel.state == .loading ? 0.2 : 1.0)
    }
    
    private var searchCityBar: some View {
        TextField("Şehir Ara", text: $viewModel.searchCityText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .disabled(viewModel.state == .loading)
            .opacity(viewModel.state == .loading ? 0.2 : 1.0)
    }
    
    private var province: some View {
        DropdownView(
            title: LocalizableString.province.rawValue.localized,
            prompt: LocalizableString.select.rawValue.localized,
            options: Consts.turkishProvinces,
            selection: $viewModel.provinceSelected
        )
        .onChange(of: viewModel.provinceSelected) { newProvince in
            withAnimation {
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
    }
    
    private var district: some View {
        DropdownView(
            title: LocalizableString.district.rawValue.localized,
            prompt: LocalizableString.select.rawValue.localized,
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
            ProgressView(LocalizableString.loading.rawValue.localized)
                .padding(.top, 200)
        case .error(let errorMessage):
            Text(errorMessage)
                .foregroundColor(.red)
                .padding(.top, 150)
        case .loaded:
            ScrollView(showsIndicators: false) {
                VStack {
                    ForEach(viewModel.filteredPharmacies, id: \.self) { pharmacy in
                        PharmaciesCell(
                            viewModel: PharmaciesCellViewModel(
                                pharmacies: pharmacy.name.orEmptyString,
                                city: pharmacy.dist.orEmptyString,
                                phone: pharmacy.phone.orEmptyString,
                                address: pharmacy.address.orEmptyString,
                                location: pharmacy.loc.orEmptyString
                            )
                        )
                        .padding(.horizontal, sizeClass == .compact ? 16 : 48)
                    }
                }
            }
        case .loadedDistricts(let districts):
            if districts.isEmpty {
                Text(LocalizableString.noDistrict.rawValue.localized)
                    .foregroundColor(.gray)
                    .padding()
            }
        case .onLoad:
            VStack(spacing: 16) {
                Image(systemName: SystemImages.storeFrontFill.rawValue)
                    .font(.system(size: 80))
                    .foregroundStyle(.gray)
                
                Text(LocalizableString.selectProvince.rawValue.localized)
                    .font(.title2)
                    .foregroundStyle(.gray)
            }
            .padding(.top, 150)
        }
    }
}


#Preview {
    CityChangeView()
}
