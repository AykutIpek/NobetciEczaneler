//
//  KeyboardToolbarModifier.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 2.09.2024.
//

import Foundation
import SwiftUI

struct KeyboardToolbarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(LocalizableString.done.rawValue.localized) {
                            hideKeyboard()
                        }
                    }
                }
            }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension View {
    func keyboardToolbar() -> some View {
        self.modifier(KeyboardToolbarModifier())
    }
}
