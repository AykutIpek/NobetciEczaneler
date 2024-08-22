//
//  View+Extension.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 22.08.2024.
//

import Foundation
import SwiftUI

extension View {
    func disableBounces() -> some View {
        modifier(DisableBouncesModifier())
    }
}

struct DisableBouncesModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onAppear {
                UIScrollView.appearance().bounces = false
            }
            .onDisappear {
                UIScrollView.appearance().bounces = false
            }
    }
}
