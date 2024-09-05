//
//  DistrictModel.swift
//  NobetciEczaneler
//
//  Created by aykut ipek on 21.08.2024.
//

import Foundation


// MARK: - Pharmacy
struct DistrictResponse: Codable {
    let success: Bool?
    let result: [DistrictModel]?
}

// MARK: - Result
struct DistrictModel: Codable {
    let text: String?
}
