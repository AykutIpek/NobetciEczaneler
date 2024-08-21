//
//  CityDropdownView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 21.08.2024.
//

import SwiftUI

struct CityDropdownView: View {
    @State private var searchText: String = ""
    @State private var isExpanded: Bool = false
    @Binding var selectedCity: String?
    var cities: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Şehir Seç")
                .font(.footnote)
                .foregroundStyle(.gray)
                .opacity(0.8)
            
            TextField("Şehir ara", text: $searchText, onEditingChanged: { _ in
                withAnimation {
                    isExpanded = true
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            .onChange(of: searchText) { _ in
                filterCities()
            }
            
            if isExpanded {
                List {
                    ForEach(filteredCities, id: \.self) { city in
                        Text(city)
                            .onTapGesture {
                                selectCity(city)
                            }
                    }
                }
                .frame(maxHeight: 200) // Maksimum yüksekliği ayarla
                .transition(.opacity)
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 4)
        .zIndex(1) // Diğer bileşenlerin üstünde olmasını sağlar
    }
    
    private var filteredCities: [String] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func filterCities() {
        withAnimation {
            isExpanded = !searchText.isEmpty
        }
    }
    
    private func selectCity(_ city: String) {
        withAnimation {
            selectedCity = city
            searchText = city
            isExpanded = false
            sendCitySelectionToAPI(city)
        }
    }
    
    private func sendCitySelectionToAPI(_ city: String) {
        // Burada API'ya seçilen şehir gönderimi yapılabilir.
        print("Selected city: \(city)")
        // Örnek olarak API isteği yapmayı simüle ediyoruz.
        // API çağrısını burada yapabilir ve ardından veriyi güncelleyebilirsiniz.
    }
}

#Preview {
    CityDropdownView(
        selectedCity: .constant(""),
        cities: ["İzmir", "Ankara", "İstanbul", "Antalya", "Bursa", "Adana"]
    )
}
