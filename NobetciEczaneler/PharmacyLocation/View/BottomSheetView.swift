//
//  BottomSheetView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 25.08.2024.
//

import SwiftUI
import MapKit

struct BottomSheetView: View {
    let pharmacy: PharmacyModel
    let onDismiss: () -> Void
    let onGetDirections: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            header
            buttonContainer
            Divider()
            bottomInfo
            Spacer()
        }
        .padding(.top)
        .padding(.bottom, 20)
        .background(.white)
    }
    
    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            title
            Spacer()
            closeButton
        }
    }
    
    private var title: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(pharmacy.name.orEmptyString)
                .font(.title2)
                .fontWeight(.bold)
            Text(LocalizableString.pharmacy.rawValue.localized)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
    
    private var closeButton: some View {
        Button(action: onDismiss) {
            Image(systemName: SystemImages.xmarkCircleFill.rawValue)
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.trailing)
        }
    }
    
    private var buttonContainer: some View {
        HStack {
            distanceButtonPrimary
            callButton
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
    
    private var distanceButtonPrimary: some View {
        Button(action: onGetDirections) {
            VStack {
                Image(systemName: SystemImages.figureWalk.rawValue)
                    .font(.title2)
                Text(LocalizableString.getDirection.rawValue.localized)
                    .font(.footnote)
            }
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(12)
            
        }
    }
    
    private var callButton: some View {
        Button(action: {
            Consts.callPharmacy(phone: pharmacy.phone)
        }) {
            VStack {
                Image(systemName: SystemImages.phoneFill.rawValue)
                    .font(.title2)
                Text(LocalizableString.call.rawValue.localized)
                    .font(.footnote)
                    .padding(.top, 1)
            }
            .foregroundStyle(.gray)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
        }
    }
    
    private var bottomInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            detailsTitle
            phoneText
            addressText
        }
        .padding(.horizontal)
    }
    
    private var detailsTitle: some View {
        HStack {
            Text(LocalizableString.details.rawValue.localized)
                .font(.headline)
            Spacer()
        }
    }
    
    @ViewBuilder
    private var phoneText: some View {
        if let phone = pharmacy.phone {
            HStack {
                Text(LocalizableString.telephone.rawValue.localized)
                Spacer()
                Text(Consts.formattedPhoneNumber(phone))
                    .foregroundColor(.blue)
            }
        }
    }
    
    @ViewBuilder
    private var addressText: some View {
        if let address = pharmacy.address {
            HStack(alignment: .top) {
                Text(LocalizableString.address.rawValue.localized)
                Spacer()
                Text(address)
                    .multilineTextAlignment(.trailing)
            }
        }
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
