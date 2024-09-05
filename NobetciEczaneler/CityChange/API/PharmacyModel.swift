//
//  Pharmacy.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 19.08.2024.
//

import Foundation
import CoreLocation

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
    
    var locationCoordinate: CLLocationCoordinate2D {
        let components = loc?.split(separator: ",").compactMap { Double($0) }
        let latitude = components?.first ?? 0.0
        let longitude = components?.last ?? 0.0
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }


    enum CodingKeys: String, CodingKey {
        case name
        case dist
        case address
        case phone
        case loc
    }
}
