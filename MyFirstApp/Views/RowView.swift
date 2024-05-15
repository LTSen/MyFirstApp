//
//  RowView.swift
//  MyFirstApp
//
//  Created by Long Sen on 3/13/24.
//

import SwiftUI

struct RowView: View {
    @Environment (ViewModel.self) var viewModel
    var todo: Todo
    
    var body: some View {
                HStack {
                    checkBoxView(isFinished: todo.isFinished)
                    todoView(todo: todo)
                }
                .addProgessView(isFinished: todo.isFinished)
    }
    
    private func todoView(todo: Todo) -> some View {
            Text(todo.title)
                .foregroundStyle(.black.opacity(0.8))
                .padding([.trailing])
    }
    
    private func checkBoxView(isFinished: Bool) -> some View {
            VStack {
                if !isFinished {
                    Image(systemName: "square")
                        .foregroundStyle(ViewModel.getPriorityColor(priority: todo.priority))
                } else {
                    Image(systemName: "checkmark.square.fill")
                }
            }
            .padding([.leading])
            .onTapGesture {
                withAnimation {
                    viewModel.toggleTodo(id: todo.id)
                }
            }
    }
}

#Preview {
    let todo = Todo(title: "plase new test")
    return RowView(todo: todo)
        .environment(ViewModel())
}
