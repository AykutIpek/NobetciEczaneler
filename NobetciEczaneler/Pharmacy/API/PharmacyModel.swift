//
//  Pharmacy.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import Foundation

// MARK: - Result
struct PharmacyResponse: Decodable {
    let success: Bool
    let result: [PharmacyModel]
}

struct PharmacyModel: Decodable, Identifiable, Hashable {
    var id: UUID = UUID()
    let name: String?
    let dist: String?
    let address: String?
    let phone: String?
    let loc: String?

    enum CodingKeys: String, CodingKey {
        case name
        case dist
        case address
        case phone
        case loc
    }
}
