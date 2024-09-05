//
//  CityPickerSheet.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 4.09.2024.
//

import SwiftUI

struct CityPickerSheet: View {
    @Binding var selectedCity: String?
    @State private var tempSelectedCity: String?
    let cities: [String]
    let onDismiss: (String?) -> Void

    init(selectedCity: Binding<String?>, cities: [String], onDismiss: @escaping (String?) -> Void) {
        self._selectedCity = selectedCity
        self._tempSelectedCity = State(initialValue: selectedCity.wrappedValue)
        self.cities = cities
        self.onDismiss = onDismiss
    }

    var body: some View {
        VStack {
            HStack {
                Button("İptal") {
                    onDismiss(selectedCity)
                }
                .foregroundColor(.red)
                Spacer()
                Button(LocalizableString.done.rawValue.localized) {
                    onDismiss(tempSelectedCity)
                }
                .foregroundColor(.red)
            }
            .padding(.horizontal)

            Picker("Select City", selection: $tempSelectedCity) {
                ForEach(cities, id: \.self) { city in
                    Text(city)
                        .tag(city as String?)
                }
            }
            .pickerStyle(.wheel)
            .onAppear {
                tempSelectedCity = selectedCity
            }
            .frame(maxHeight: 200)
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    CityPickerSheet(
        selectedCity: .constant("İzmir"),
        cities: Consts.turkishProvinces
    ) { _ in
        //
    }
}
