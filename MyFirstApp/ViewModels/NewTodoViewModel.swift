//
//  GroceriesViewModel.swift
//  MyFirstApp
//
//  Created by Long Sen on 5/6/24.
//

import SwiftUI

@Observable
class NewTodoViewModel {
    
    var newTodo = ""
    var groceryStores: [GroceryStore]
    var todoPriority: Todo.Priority = .low
    var todoLocation: Todo.Location = .none
    var todoDescription = ""
    
    init(groceryStores: [GroceryStore]) {
        self.groceryStores = groceryStores
    }
    
    func toggleGroceryStore(id: UUID) {
        guard let index = groceryStores.firstIndex(where: { $0.id == id }) else { return }
        groceryStores[index].toggleSelected()
    }
    
    func isSelectAll() -> Bool {
        groceryStores.filter({ $0.selected }).count < groceryStores.count
    }
    
    func toggleAll() {
        let toggleValue = isSelectAll()
        for index in groceryStores.indices {
            groceryStores[index].selected = toggleValue
        }
    }
    
    func updateGorceriesLocation() {
        let selectedGorceries = groceryStores.filter({$0.selected})
        todoLocation = selectedGorceries.count == 0 ? .none : .grocery(selectedGorceries)
    }
    
    func createNewTodo() -> Todo {
        Todo(title: newTodo, description: todoDescription, priority: todoPriority, location: todoLocation)
    }
}
