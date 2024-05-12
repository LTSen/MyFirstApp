//
//  Todo.swift
//  MyFirstApp
//
//  Created by Long Sen on 3/13/24.
//

import Foundation

struct Todo: Codable, Identifiable {
    let id = UUID()
    var title: String = ""
    var description = ""
    let dateCreated = Date()
    var priority: Priority = .low
    var location: Location = .none
    var isFinished = false
    
    enum Priority: String, Codable, CaseIterable {
        case high, medium, low
        
        func getText() -> String {
            switch self {
            case .low:
                return "Low Priority"
            case .medium:
                return "Medium Priority"
            case .high:
                return "High Priority"
            }
        }
    }
    
    enum Location: Codable, CaseIterable, Hashable {
        case none, current, getInCar, getOutCar, grocery([GroceryStore]), custom
        
        static var allCases: [Location] {
            return [.none, .current, .getInCar, .getOutCar, .grocery([]), .custom]
        }
        
        func getText() -> String {
            switch self {
            case .none:
                return "None"
            case .current:
                return "Current"
            case .getInCar:
                return "Getting In"
            case .getOutCar:
                return "Getting Out"
            case .grocery(let value):
                if value.count > 0 {
                    return "Grocery \(value[0].storeName)"
                }
                return "Grocery"
            case .custom:
                return "Custom"
            }
        }
    }
    
    mutating func toggole() {
        isFinished.toggle()
    }
}
