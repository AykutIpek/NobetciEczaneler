//
//  MainCellViewModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 20.08.2024.
//

import Foundation
import SwiftUI

struct MainCellViewModel {
    let systemImage: String
    let cellTitle: String
    let backgroundImage: ImageResource
    let color: [Color]
    let action: (() -> Void)
    
    init(
        systemImage: String,
        cellTitle: String,
        backgroundImage: ImageResource,
        color: [Color],
        action: @escaping () -> Void
    ) {
        self.systemImage = systemImage
        self.cellTitle = cellTitle
        self.backgroundImage = backgroundImage
        self.color = color
        self.action = action
    }
}
