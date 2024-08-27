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
    let destinationView: AnyView
    
    init<V: View>(
        systemImage: String,
        cellTitle: String,
        backgroundImage: ImageResource,
        color: [Color],
        destinationView: V? = nil
    ) {
        self.systemImage = systemImage
        self.cellTitle = cellTitle
        self.backgroundImage = backgroundImage
        self.color = color
        self.destinationView = AnyView(destinationView)
    }
}
