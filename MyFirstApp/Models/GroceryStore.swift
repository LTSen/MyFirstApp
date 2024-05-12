//
//  GroceryStore.swift
//  MyFirstApp
//
//  Created by Long Sen on 5/6/24.
//

import Foundation

struct GroceryStore: Codable, Identifiable, Hashable {
    
    let id = UUID()
    let storeName: String
    var selected: Bool = false
    
    mutating func toggleSelected() {
        selected.toggle()
    }
}
