//
//  MainCells.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

struct MainCells: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "list.bullet.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .foregroundStyle(.white)
                .padding(.leading, 24)
            Text("İLLERE GÖRE")
                .font(.title2)
                .foregroundStyle(.white)
                .bold()
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 110)
        .background {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.red,
                        Color.red.opacity(0.8),
                        Color.red.opacity(0.5)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                Image(.map)
                    .opacity(0.2)
            }
        }
        .clipShape(.capsule)
        .shadow(radius: 10, x: 10)
        .onTapGesture {
            print("Clicked")
        }
    }
}

#Preview {
    MainCells()
}
