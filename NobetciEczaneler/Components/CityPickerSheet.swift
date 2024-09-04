//
//  CityPickerSheet.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 4.09.2024.
//

import SwiftUI

struct CityPickerSheet: View {
    @Binding var selectedCity: String
    let cities: [String]
    let onDismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button("İptal") {
                    onDismiss()
                }
                .foregroundColor(.red)
                Spacer()
                Button("Tamam") {
                    onDismiss()
                }
                .foregroundColor(.red)
            }
            .padding()
            
            Picker(selection: $selectedCity, label: Text("Select City")) {
                ForEach(cities, id: \.self) { city in
                    Text(city)
                        .tag(city)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    CityPickerSheet(
        selectedCity: .constant("İzmir"),
        cities: Consts.turkishProvinces
    ) {
        //
    }
}
