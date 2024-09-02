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
        NavigationLink(destination: viewModel.destinationView) {
            HStack(spacing: 16) {
                Image(systemName: viewModel.systemImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.white)
                    .padding(.leading, 24)
                Text(viewModel.cellTitle)
                    .font(.title3)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .bold()
                Spacer()
            }
            .frame(
                width: UIScreen.main.sizeCheck(.iphone6)
                ? UIScreen.main.bounds.width - 32
                : UIScreen.main.bounds.width * 0.9,
                height: 110
            )
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
        }
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
                ],
                destinationView: HomeView()
            )
        )
    }
}
