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
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                pharmaciesText
                cityText
                phoneText
                locationText
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
                Image(systemName: "pin.fill")
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
                Image(systemName: "phone.fill")
                    .foregroundStyle(.red)
                Text(phone)
                    .foregroundStyle(.black)
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    private var locationText: some View {
        if let location = viewModel.location, location.isNotEmpty {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "location.fill")
                    .foregroundStyle(.red)
                Text(location)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
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
                let tel = "tel://"
                let formattedString = tel + phone
                guard let url = URL(string: formattedString) else { return }
                UIApplication.shared.open(url)
            } label: {
                HStack {
                    HStack {
                        Image(systemName: "phone.circle.fill")
                            .foregroundStyle(.blue)
                            .font(.largeTitle)
                        
                        Text("Ara")
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
        if let location = viewModel.location, location.isNotEmpty {
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "location.circle.fill")
                        .foregroundStyle(.blue)
                        .font(.largeTitle)
                    
                    Text("Yol Tarifi")
                        .foregroundStyle(.black)
                        .font(.subheadline)
                        .bold()
                }
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
                    location: "İstasyon Mahellesi, Leylak Caddesi no:16/1 Erdal apartmanı"
                )
            )
            
            PharmaciesCell(
                viewModel: PharmaciesCellViewModel(
                    pharmacies: "Demir Eczanesi",
                    city: "İzmir",
                    phone: .empty,
                    location: "İstasyon Mahellesi, Leylak Caddesi no:16/1 Erdal apartmanı"
                )
            )
            
            PharmaciesCell(
                viewModel: PharmaciesCellViewModel(
                    pharmacies: "Demir Eczanesi",
                    city: "İzmir",
                    phone: .empty,
                    location: .empty
                )
            )
            
            PharmaciesCell(
                viewModel: PharmaciesCellViewModel(
                    pharmacies: "Demir Eczanesi",
                    city: "İzmir",
                    phone: .empty,
                    location: "İstasyon Mahellesi, Leylak Caddesi no:16/1 Erdal apartmanı"
                )
            )
            
        }
    }
}
