//
//  CityPickerStyle.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 21.08.2024.
//

import SwiftUI

//struct CityPickerView: View {
//    @Binding var selectedCity: String? // Seçilen şehir dışarıdan binding olarak alınır
//    var cities: [String] // Şehirler listesi dışarıdan verilir
//
//    var body: some View {
//        Menu {
//            ScrollView { // ScrollView ile maksimum 10 şehir gösterilecek şekilde yapılandırma
//                ForEach(cities.prefix(5), id: \.self) { city in
//                    Button(action: {
//                        selectedCity = city // Şehir seçildiğinde selectedCity güncellenir
//                    }) {
//                        Text(city)
//                    }
//                }
//            }
//            .frame(height: 5) // Maximum 10 şehir gösterilecek şekilde yüksekliği ayarlıyoruz
//        } label: {
//            HStack {
//                Text(selectedCity ?? "Şehir Seç")
//                    .foregroundColor(selectedCity == nil ? .gray : .black)
//                Spacer()
//                Image(systemName: "chevron.down")
//                    .foregroundColor(.gray)
//            }
//            .padding()
//            .frame(width: 300, height: 40)
//            .background(Color.white)
//            .cornerRadius(10)
//            .shadow(radius: 4)
//        }
//    }
//}

struct CityPickerView: View {
    @Binding var selectedCity: String?
    @State private var isExpanded: Bool = false
    var cities: [String] // Şehirler listesi dışarıdan verilir

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(selectedCity ?? "Şehir Seç")
                    .foregroundColor(selectedCity == nil ? .gray : .black)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(isExpanded ? 180 : .zero))
            }
            .padding()
            .frame(width: 200, height: 40)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 4)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }

            if isExpanded {
                List {
                    ForEach(cities, id: \.self) { city in
                        Button(action: {
                            selectedCity = city
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            Text(city)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .foregroundColor(.black)
                    }
                }
                .frame(width: 200)
                .background(Color.white)
                .frame(maxHeight: 300)
                .listStyle(PlainListStyle())
                .cornerRadius(10)
                .shadow(radius: 4)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
    }
}


#Preview {
    CityPickerView(selectedCity: .constant("izmir"), cities: Consts.turkishProvinces)
}
