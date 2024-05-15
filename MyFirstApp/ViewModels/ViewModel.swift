//
//  File.swift
//  MyFirstApp
//
//  Created by Long Sen on 3/10/24.
//

import Foundation
import Combine
import SwiftUI

typealias TodoBySection = (String, [Todo])

@Observable
class ViewModel{
    
    private var todoItems: [Todo] = [Todo(title: "text"), Todo(title: "again", isFinished: true), Todo(title: "next", priority: .high), Todo(title: "why is it")]
    var todoList: [TodoBySection] = []
    var groceriesStore = [GroceryStore(storeName: "Walmart"), GroceryStore(storeName: "Kroger"), GroceryStore(storeName: "Costco"), GroceryStore(storeName: "Sam's club"), GroceryStore(storeName: "The Home Depot")]
//    private let locationService = LocationService()
    
    var section: Section = .Completed {
        didSet {
            updateTodoList()
        }
    }
        
    init() {
        updateTodoList()
    }
    
    func toggleTodo(id: UUID) {
        if let index = todoItems.firstIndex(where: {$0.id == id }) {
            todoItems[index].toggole()
        }
        updateTodoList()
    }
    
    func updateTodoList() {
        switch section {
        case .None:
            todoList = [("Items", todoItems)]
        case .Completed:
            var todoSections = [(String, [Todo])]()
            let items = todoItems.filter({!$0.isFinished})
            let completedItems = todoItems.filter({$0.isFinished})
            if !items.isEmpty {todoSections.append(("Items", items))}
            todoSections.append(("Completed", completedItems))
            todoList = todoSections
        }
    }
    
    func isSectionFinished(subsection: String) -> Bool {
        guard let subsection = todoList.first(where: {$0.0 == subsection }), !subsection.1.isEmpty else { return false }
        switch section {
        case .None:
            return subsection.1.filter({ $0.isFinished }).count == subsection.1.count
        case .Completed:
            return subsection.1.filter({ $0.isFinished }).count == subsection.1.count
        }
        
    }
    
    func addNewTodo(_ todo: Todo) {
        todoItems.append(todo)
        updateTodoList()
    }
    
    static func getPriorityColor(priority: Todo.Priority) -> Color {
        switch priority {
        case .low:
            return .gray
        case .medium:
            return .yellow
        case .high:
            return .red
        }
    }
    
    enum Section: String, CaseIterable {
        case None, Completed
    }
    
}
