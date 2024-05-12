//
//  ContentView.swift
//  MyFirstApp
//
//  Created by Long Sen on 3/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    @State private var showNewTodoOverlay = true
    
    private var screenWidth = UIScreen.main.bounds.width
    private var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationView {
            mainView
                .overlay(alignment: .bottom, content: {
                    if !showNewTodoOverlay {
                        let newToDoViewModel = NewTodoViewModel(groceryStores: viewModel.groceriesStore)
                        NewToDoView(newTodoViewModel: newToDoViewModel) { todo in
                            if let todo {
                                viewModel.addNewTodo(todo)
                            }
                            showNewTodoOverlay.toggle()
                        }
                    }
                })
                .background(.gray.opacity(0.35))
                .environment(viewModel)
        }
    }
    
    var mainView: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.todoList, id: \.0) { section in
                    sectionView(sectionTitle: section.0, items: section.1)
                }
                .padding(10)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button("Sort") {}
                            groupMenu
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
            addButton
                .position(x: screenWidth - 70, y: screenHeight - 180)
        }
    }
    
    private func sectionView(sectionTitle: String, items: [Todo]) -> some View {
            ZStack(alignment:.leading) {
                CustomProgressView(isFinished: viewModel.isSectionFinished(subsection: sectionTitle), isCornerRadius: true)
                VStack(alignment: .leading, spacing: 0) {
                    Text(sectionTitle)
                        .padding([.leading, .trailing])
                    ForEach(items) { item in
                        RowView(todo: item)
                    }
                }
                .padding([.top, .bottom])
            }
        }
    
    private var groupMenu: some View {
        Menu {
            ForEach(ViewModel.Section.allCases, id: \.self) { section in
                subGroupMenu(by: section)
            }
        } label: {
            Text("Group By")
        }
    }
    
    private func subGroupMenu(by section: ViewModel.Section) -> some View {
        Button(action: { viewModel.section = section }, label: {
            HStack {
                Text(section.rawValue)
                Spacer()
                if section == viewModel.section {
                    Image(systemName: "checkmark")
                }
            }
        })
    }
    
    private var addButton: some View {
        Button(action: {
            withAnimation(.easeIn) {
                showNewTodoOverlay.toggle()
            }
        }, label: {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 70))
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
