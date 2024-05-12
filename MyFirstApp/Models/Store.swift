//
//  Store.swift
//  MyFirstApp
//
//  Created by Long Sen on 3/10/24.
//

import Foundation

struct Store: Codable {
    let streetAddress: String
    let city: String
    let zipCode: String
    let state: String
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case streetAddress = "street_address"
        case city
        case zipCode = "zip_code"
        case state
        case latitude
        case longitude
    }
    
    var fullAddress: String {
        "\(streetAddress) \(city), \(state) \(zipCode)"
    }
}
