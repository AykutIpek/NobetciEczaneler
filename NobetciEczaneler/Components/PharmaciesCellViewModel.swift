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
    var address: String?
    var location: String?
    
    init(
        pharmacies: String? = nil,
        city: String? = nil,
        phone: String? = nil,
        address: String? = nil,
        location: String? = nil
    ) {
        self.pharmacies = pharmacies
        self.city = city
        self.phone = phone
        self.address = address
        self.location = location
    }
    
    var checkLocationAndPhoneText: Bool {
        (address.orEmptyString).isNotEmpty || (phone.orEmptyString).isNotEmpty
    }
}
