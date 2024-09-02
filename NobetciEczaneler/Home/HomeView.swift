//
//  HomeView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var languageManager = LanguageManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack(spacing: 16) {
                    Spacer()
                    logo
                    Spacer()
                    provinceCell
                    locationCell
                    Spacer()
                }
            }
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        languageManager.toggleLanguage()
                    }) {
                        Image(.translate)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            if let window = windowScene.windows.first {
                window.rootViewController = UIHostingController(rootView: HomeView())
                window.makeKeyAndVisible()
            }
        }
    }
    
    private var background: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.red.opacity(0.7), Color.blue.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var logo: some View {
        Image(.nobetciEczane)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 200)
            .clipShape(.circle)
            .shadow(radius: 10, x: 10)
    }
    
    private var provinceCell: some View {
        MainCell(
            viewModel: MainCellViewModel(
                systemImage: SystemImages.listBulletCircle.rawValue,
                cellTitle: LocalizableString.provinceTitle.rawValue.localized,
                backgroundImage: .map,
                color: [
                    Color.red,
                    Color.red.opacity(0.8),
                    Color.red.opacity(0.6)
                ],
                destinationView: PharmacyView()
            )
        )
    }
    
    private var locationCell: some View {
        MainCell(
            viewModel: MainCellViewModel(
                systemImage: SystemImages.locationCircle.rawValue,
                cellTitle: LocalizableString.districtTitle.rawValue.localized,
                backgroundImage: .pin,
                color: [
                    Color.blue,
                    Color.blue.opacity(0.8),
                    Color.blue.opacity(0.4)
                ],
                destinationView: LocationView()
            )
        )
    }
}

#Preview {
    HomeView()
}
