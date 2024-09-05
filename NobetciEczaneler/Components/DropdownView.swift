//
//  DropdownView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 20.08.2024.
//

import SwiftUI

struct DropdownView: View {
    let title: String
    let prompt: String
    let options: [String]
    @Binding var selection: String?
    @State private var showCityPicker = false

    var body: some View {
        VStack(alignment: .leading) {
            header
            HStack {
                Text(selection ?? prompt)
                    .font(.subheadline)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            .frame(height: 40)
            .padding(.horizontal)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 4)
            .onTapGesture {
                showCityPicker.toggle()
            }
            .sheet(isPresented: $showCityPicker) {
                CityPickerSheet(selectedCity: $selection, cities: options) { newSelectedCity in
                    selection = newSelectedCity
                    showCityPicker = false
                }
                .presentationDetents([.height(UIScreen.main.bounds.height * 0.3)])
                .presentationDragIndicator(.visible)
            }
        }
    }

    private var header: some View {
        Text(title)
            .font(.footnote)
            .foregroundStyle(.gray)
            .opacity(0.8)
    }
}

#Preview {
    DropdownView(
        title: "İl",
        prompt: "İl Seçin",
        options: Consts.turkishProvinces,
        selection: .constant("Ankara")
    )
}
