//
//  CityChangeState.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 22.08.2024.
//

import Foundation

enum CityChangeState {
    case loading
    case error(String)
    case loaded([PharmacyModel])
    case loadedDistricts([String])
    case onLoad
}
