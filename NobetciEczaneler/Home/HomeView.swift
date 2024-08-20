//
//  HomeView.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.red.opacity(0.6), Color.blue.opacity(0.8)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                VStack(spacing: 16) {
                    Spacer()
                    Image(.nobetciEczane)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(.circle)
                        .shadow(radius: 10, x: 10)
                    
                    Spacer()
                    MainCell(
                        viewModel: MainCellViewModel(
                            systemImage: "list.bullet.circle",
                            cellTitle: "İLLERE GÖRE",
                            backgroundImage: .map,
                            color: [
                                Color.red,
                                Color.red.opacity(0.8),
                                Color.red.opacity(0.6)
                            ], action: {
                                // Empty action
                            }
                        )
                    )
                    
                    MainCell(
                        viewModel: MainCellViewModel(
                            systemImage: "location.circle",
                            cellTitle: "YAKINIMDAKİLER",
                            backgroundImage: .pin,
                            color: [
                                Color.blue,
                                Color.blue.opacity(0.8),
                                Color.blue.opacity(0.4)
                            ], action: {
                                // Empty action
                            }
                        )
                    )
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}
