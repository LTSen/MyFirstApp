//
//  PriorityRowView.swift
//  MyFirstApp
//
//  Created by Long Sen on 5/4/24.
//

import SwiftUI

struct PriorityRowView: View {
    let priority: Todo.Priority
    
    var body: some View {
        HStack {
            Image(systemName: "flag")
                .foregroundStyle(ViewModel.getPriorityColor(priority: priority))
            Text(priority.getText())
        }
    }
}

#Preview {
    PriorityRowView(priority: .high)
}
