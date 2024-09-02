//
//  LanguageManager.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 2.09.2024.
//

import Foundation

final class LanguageManager: ObservableObject {
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set([currentLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            Bundle.resetLocalization() // Bundle'ı güncelle
        }
    }

    init() {
        let savedLanguage = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
        self.currentLanguage = savedLanguage
    }

    func toggleLanguage() {
        if currentLanguage == "en" {
            currentLanguage = "tr"
        } else {
            currentLanguage = "en"
        }

        NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
    }
}

extension Bundle {
    private static var bundle: Bundle!

    public static func localizedBundle() -> Bundle {
        if bundle == nil {
            resetLocalization()
        }
        return bundle
    }

    public static func resetLocalization() {
        let languageCode = UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.first ?? "en"
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") {
            bundle = Bundle(path: path)
        } else {
            bundle = Bundle.main
        }
    }
}
