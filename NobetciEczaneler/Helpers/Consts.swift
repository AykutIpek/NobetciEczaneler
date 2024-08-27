//
//  Consts.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 21.08.2024.
//

import Foundation
import SwiftUI

struct Consts {
    static let turkishProvinces: [String] = [
        "Adana", "Adıyaman", "Afyonkarahisar", "Ağrı", "Aksaray", "Amasya", "Ankara", "Antalya",
        "Ardahan", "Artvin", "Aydın", "Balıkesir", "Bartın", "Batman", "Bayburt", "Bilecik",
        "Bingöl", "Bitlis", "Bolu", "Burdur", "Bursa", "Çanakkale", "Çankırı", "Çorum",
        "Denizli", "Diyarbakır", "Düzce", "Edirne", "Elazığ", "Erzincan", "Erzurum",
        "Eskişehir", "Gaziantep", "Giresun", "Gümüşhane", "Hakkâri", "Hatay", "Iğdır",
        "Isparta", "İstanbul", "İzmir", "Kahramanmaraş", "Karabük", "Karaman", "Kars",
        "Kastamonu", "Kayseri", "Kırıkkale", "Kırklareli", "Kırşehir", "Kilis", "Kocaeli",
        "Konya", "Kütahya", "Malatya", "Manisa", "Mardin", "Mersin", "Muğla", "Muş",
        "Nevşehir", "Niğde", "Ordu", "Osmaniye", "Rize", "Sakarya", "Samsun", "Şanlıurfa",
        "Siirt", "Sinop", "Sivas", "Şırnak", "Tekirdağ", "Tokat", "Trabzon", "Tunceli",
        "Uşak", "Van", "Yalova", "Yozgat", "Zonguldak"
    ]
    
    static func callPharmacy(phone: String?) {
        guard let phoneNumber = phone?.replacingOccurrences(of: " ", with: ""),
              let phoneURL = URL(string: "tel://\(phoneNumber)"),
              UIApplication.shared.canOpenURL(phoneURL) else {
            return
        }
        UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
    }
    
    static let sheetCoordinateSpacer = "sheetCoordinateSpace"
    
    static let turkishToEnglishMapping: [String: String] = [
        "Ç": "C", "Ğ": "G", "İ": "I", "Ö": "O", "Ş": "S", "Ü": "U",
        "ç": "c", "ğ": "g", "ı": "i", "ö": "o", "ş": "s", "ü": "u"
    ]
}
