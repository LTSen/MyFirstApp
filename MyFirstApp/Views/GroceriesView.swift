//
//  GroceriesView.swift
//  MyFirstApp
//
//  Created by Long Sen on 5/6/24.
//

import SwiftUI

struct GroceriesView: View {
    
    @Bindable var newTodoViewModel: NewTodoViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    contentListView
                }, header: {
                    sectionHeader
                })
            }
            .navigationTitle("Groceries")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    backButton
                })
            }
        }
    }
    
    var contentListView: some View {
        ForEach(newTodoViewModel.groceryStores) { grocery in
            HStack{
                Image(systemName: "checkmark")
                    .opacity(grocery.selected ? 1 : 0)
                    .foregroundStyle(.green)
                Text(grocery.storeName)
            }
            .onTapGesture {
                newTodoViewModel.toggleGroceryStore(id: grocery.id)
            }
        }
    }
    
    var sectionHeader: some View {
        HStack {
            Spacer()
            Text(newTodoViewModel.isSelectAll() ? "Select All" : "Deselect All")
                .textCase(.none)
                .onTapGesture {
                    newTodoViewModel.toggleAll()
                }
        }
    }
    
    var backButton: some View  {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        })
    }
}

#Preview {
    GroceriesView(newTodoViewModel: NewTodoViewModel(groceryStores: [GroceryStore(storeName: "Walmart"), GroceryStore(storeName: "Kroger"), GroceryStore(storeName: "Costco"), GroceryStore(storeName: "Sam's club"), GroceryStore(storeName: "The Home Depot")]))
}
