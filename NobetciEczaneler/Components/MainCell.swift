//
//  MainCells.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

struct MainCell: View {
    let viewModel: MainCellViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.systemImage)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .foregroundStyle(.white)
                .padding(.leading, 24)
            Text(viewModel.cellTitle)
                .font(.title2)
                .foregroundStyle(.white)
                .bold()
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 32, height: 110)
        .background {
            ZStack {
                LinearGradient(
                    colors: viewModel.color,
                    startPoint: .leading,
                    endPoint: .trailing
                )
                Image(viewModel.backgroundImage)
                    .opacity(0.2)
            }
        }
        .clipShape(.capsule)
        .shadow(radius: 10, x: 10)
        .onTapGesture(perform: viewModel.action)
    }
}

#Preview {
    VStack {
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
    }
}
