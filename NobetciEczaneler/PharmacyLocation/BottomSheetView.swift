//
//  BottomSheetView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 25.08.2024.
//

import SwiftUI

struct BottomSheetView: View {
    let pharmacy: PharmacyModel
    let onDismiss: () -> Void
    let onGetDirections: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(pharmacy.name.orEmptyString)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("Eczane")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
            }

            HStack {
                Button(action: onGetDirections) {
                    VStack {
                        Image(systemName: "figure.walk")
                            .font(.title2)
                        Text("Yön Tarifi Al")
                            .font(.footnote)
                    }
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                }

                Button(action: {
                    
                }) {
                    VStack {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                        Text("Ara")
                            .font(.footnote)
                    }
                    .foregroundStyle(.gray)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal)

            Divider()

            // Details Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Ayrıntılar")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }

                // Contact info
                if let phone = pharmacy.phone {
                    HStack {
                        Text("Telefon:")
                            .foregroundColor(.black)
                        Spacer()
                        Text(phone)
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.trailing)
                    }
                }

                // Address (supports multiline)
                if let address = pharmacy.address {
                    HStack(alignment: .top) {
                        Text("Adres:")
                            .foregroundColor(.black)
                        Spacer()
                        Text(address)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.trailing)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
        .background(Color.white)
    }
}

#Preview {
    BottomSheetView(
        pharmacy: PharmacyModel(
            id: UUID(),
            name: "Faruk",
            dist: "İzmir",
            address: "dsadsadsadsadsadddadsadsadsa",
            phone: "559595555",
            loc: "38.19552,26.83664"
        )) {
            
        } onGetDirections: {
            
        }
}
