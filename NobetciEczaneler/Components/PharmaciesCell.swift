//
//  PharmaciesCell.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 21.08.2024.
//

import SwiftUI

struct PharmaciesCell: View {
    var viewModel: PharmaciesCellViewModel
    @State private var cellDidTapped: Bool = false
    
    var body: some View {
        NavigationStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    pharmaciesText
                    cityText
                    phoneText
                    addressText
                    buttonsArea
                }
                chevronRight
            }
            .padding(.all)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 12))
            .shadow(radius: 10, x: 2, y: 10)
            .padding(.horizontal)
            .onTapGesture {
                guard viewModel.checkLocationAndPhoneText else { return }
                withAnimation(.bouncy) {
                    cellDidTapped.toggle()
                }
        }
        }
    }
    
    @ViewBuilder
    private var pharmaciesText: some View {
        if let pharmacies = viewModel.pharmacies, pharmacies.isNotEmpty {
            Text(pharmacies)
                .foregroundStyle(.black)
                .font(.title2)
                .bold()
        }
    }
    
    @ViewBuilder
    private var cityText: some View {
        if let city = viewModel.city, city.isNotEmpty {
            HStack {
                Image(systemName: SystemImages.pinFill.rawValue)
                    .foregroundStyle(.red)
                Text(city)
                    .foregroundStyle(.black)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var phoneText: some View {
        if let phone = viewModel.phone, phone.isNotEmpty {
            HStack {
                Image(systemName: SystemImages.phoneFill.rawValue)
                    .foregroundStyle(.red)
                Text(phone)
                    .foregroundStyle(.black)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var addressText: some View {
        if let address = viewModel.address, address.isNotEmpty {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: SystemImages.locationFill.rawValue)
                    .foregroundStyle(.red)
                Text(address)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var buttonsArea: some View {
        if cellDidTapped {
            HStack {
                callButton
                locationButton
            }
        }
    }
    
    @ViewBuilder
    private var callButton: some View {
        if let phone = viewModel.phone, phone.isNotEmpty {
            Button {
                Consts.callPharmacy(phone: phone)
            } label: {
                HStack {
                    HStack {
                        Image(systemName: SystemImages.phoneCircleFill.rawValue)
                            .foregroundStyle(.blue)
                            .font(.largeTitle)
                        
                        Text(LocalizableString.call.rawValue.localized)
                            .foregroundStyle(.black)
                            .font(.subheadline)
                            .bold()
                    }
                    .padding(.trailing, 40)
                }
            }
        }
    }
    
    @ViewBuilder
    private var locationButton: some View {
        NavigationLink {
            PharmacyLocationView(
                viewModel: PharmacyLocationViewModel(
                    pharmacy: PharmacyModel(
                        name: viewModel.pharmacies,
                        dist: viewModel.city,
                        address: viewModel.address,
                        phone: viewModel.phone,
                        loc: viewModel.location
                    )
                )
            )
        } label: {
            HStack {
                Image(systemName: SystemImages.locationCircleFill.rawValue)
                    .foregroundStyle(.blue)
                    .font(.largeTitle)
                
                Text(LocalizableString.directions.rawValue.localized)
                    .foregroundStyle(.black)
                    .font(.subheadline)
                    .bold()
            }
        }
    }
    
    @ViewBuilder
    private var chevronRight: some View {
        if viewModel.checkLocationAndPhoneText {
            Image(systemName: SystemImages.chevronRight.rawValue)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .rotationEffect(.degrees(cellDidTapped ? 90 : .zero))
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            PharmaciesCell(
                viewModel: PharmaciesCellViewModel(
                    pharmacies: "Demir Eczanesi",
                    city: "İzmir",
                    phone: "05354312365",
                    address: "KOYUNCU MAHALLESİ İSTANSYON CADDESİ NO:3 BUCA/ KAYNAKLAR ÇEŞME YANI",
                    location:  "32.0000, 32.0000"
                )
            )
            
            PharmaciesCell(
                viewModel: PharmaciesCellViewModel(
                    pharmacies: "Demir Eczanesi",
                    city: "İzmir",
                    phone: .empty,
                    address: "İstasyon Mahellesi, Leylak Caddesi no:16/1 Erdal apartmanı",
                    location:  "32.0000, 32.0000"
                )
            )
            
            PharmaciesCell(
                viewModel: PharmaciesCellViewModel(
                    pharmacies: "Demir Eczanesi",
                    city: "İzmir",
                    phone: .empty,
                    address: .empty,
                    location: "32.0000, 32.0000"
                )
            )
            
            PharmaciesCell(
                viewModel: PharmaciesCellViewModel(
                    pharmacies: "Demir Eczanesi",
                    city: "İzmir",
                    phone: .empty,
                    address: "İstasyon Mahellesi, Leylak Caddesi no:16/1 Erdal apartmanı", 
                    location: "32.0000, 32.0000"
                )
            )
            
        }
    }
}
