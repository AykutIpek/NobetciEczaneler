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
        VStack {
            HStack {
                Text(pharmacy.name.orEmptyString)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            
            HStack {
                Button(action: {
                    onGetDirections()
                }) {
                    Text("Directions")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Button(action: {
                    onDismiss()
                }) {
                    Text("Dismiss")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}
