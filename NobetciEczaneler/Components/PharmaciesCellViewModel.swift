//
//  PharmaciesCellViewModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 22.08.2024.
//

import Foundation


struct PharmaciesCellViewModel {
    var pharmacies: String?
    var city: String?
    var phone: String?
    var location: String?
    
    init(pharmacies: String? = nil, city: String? = nil, phone: String? = nil, location: String? = nil) {
        self.pharmacies = pharmacies
        self.city = city
        self.phone = phone
        self.location = location
    }
    
    var checkLocationAndPhoneText: Bool {
        (location.orEmptyString).isNotEmpty || (phone.orEmptyString).isNotEmpty
    }
}
