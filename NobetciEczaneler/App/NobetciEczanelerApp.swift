//
//  NobetciEczanelerApp.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import SwiftUI

@main
struct NobetciEczanelerApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.colorScheme, .light)
        }
    }
}
