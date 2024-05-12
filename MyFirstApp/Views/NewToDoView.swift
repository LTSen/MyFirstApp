//
//  NewToDoView.swift
//  MyFirstApp
//
//  Created by Long Sen on 5/2/24.
//

import SwiftUI

struct NewToDoView: View {
    
    @Bindable var newTodoViewModel: NewTodoViewModel
    var onCompletion: ((Todo?) -> Void)?
    @FocusState private var isFocused: Bool
    @State var newTodoAttributeBox: NewTodoAttributeBox = .none
    @State var isGroceriesSheetPresented = false
    
    
    var body: some View {
        mainView
            .onTapGesture {
                newTodoAttributeBox = .none
            }
            .overlay(alignment: .bottomLeading, content: {
                overLayAttributeView
            })
            .sheet(isPresented: $isGroceriesSheetPresented, content: {
                GroceriesView(newTodoViewModel: newTodoViewModel)
            })
            .onChange(of: isGroceriesSheetPresented, { oldValue, newValue in
                if newValue == false {
                    newTodoViewModel.updateGorceriesLocation()
                }
            })
            .backgroundStyle(.gray.opacity(0.2))
    }
    
    var mainView: some View {
        VStack(spacing: 0) {
            Color.gray.opacity(0.2)
                .contentShape(Rectangle())
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                    onCompletion?(nil)
                }
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 150)
                .foregroundStyle(.white)
                .overlay(alignment: .topLeading, content: {
                    TextField(text: $newTodoViewModel.newTodo, label: {
                        Text("Todo")
                    })
                    .focused($isFocused)
                    .keyboardType(.alphabet).autocorrectionDisabled()
                    .padding()
                })
                .overlay(alignment: .bottom, content: {
                    taskPanel
                })
                .onAppear {
                    isFocused = true
                }
        }
    }
    
    var overLayAttributeView: some View {
        Group {
            if newTodoAttributeBox == .prioroty {
                CustomListView(items: Todo.Priority.allCases, content: { priority in
                    PriorityRowView(priority: priority)
                }, tappedItem: { tappedPriority in
                    newTodoViewModel.todoPriority = tappedPriority
                    newTodoAttributeBox = .none
                })
                .offset(x: 20, y: -50)
            }
            else if newTodoAttributeBox == .location {
                CustomListView(items: Todo.Location.allCases, content: { location in
                    LocationRowView(location: location)
                }, tappedItem: { tappedLocation in
                    newTodoAttributeBox = .none
                    newTodoViewModel.todoLocation = tappedLocation
                    if tappedLocation == .grocery([]) {
                        isGroceriesSheetPresented = true
                    }
                })
                .offset(x: 20, y: -50)
            }
        }
    }
    
    var taskPanel: some View {
        HStack(spacing: 16) {
            Image(systemName: "flag")
                .customeImageStyle(foregroundStyle: ViewModel.getPriorityColor(priority: newTodoViewModel.todoPriority))
                .onTapGesture {
                    toggleAttributeBox(attribute: .prioroty)
                }
            Image(systemName: "location.fill")
                .customeImageStyle(foregroundStyle: newTodoViewModel.todoLocation == .none ? .gray : .blue)
                .onTapGesture {
                    toggleAttributeBox(attribute: .location)
                }
            Spacer()
            Button(action: {
                isFocused = false
                onCompletion?(newTodoViewModel.createNewTodo())
            }, label: {
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundStyle(.black)
                    .font(.system(size: 32))
                    .opacity(newTodoViewModel.newTodo == "" ? 0.1 : 1)
            })
            .disabled(newTodoViewModel.newTodo == "")
        }
        .padding(16)
    }
    
    private func toggleAttributeBox(attribute: NewTodoAttributeBox) {
        guard newTodoAttributeBox == attribute else {
            newTodoAttributeBox = attribute
            return
        }
        switch newTodoAttributeBox {
        case .none:
            newTodoAttributeBox = attribute
        case .prioroty:
            newTodoAttributeBox = .none
        case .location:
            newTodoAttributeBox = .none
        }
    }
    
    enum NewTodoAttributeBox {
        case none, prioroty, location
    }
}

struct CustomImageView<S>: ViewModifier where S: ShapeStyle {
    
    var fontSize: CGFloat
    var style: S
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize))
            .foregroundStyle(style)
    }
}

extension View {
    func customeImageStyle<S>(fontSize: CGFloat = 24, foregroundStyle: S) -> some View where S: ShapeStyle {
        self.modifier(CustomImageView(fontSize: fontSize, style: foregroundStyle))
    }
}

#Preview {
    NewToDoView(newTodoViewModel: NewTodoViewModel(groceryStores: [GroceryStore(storeName: "Walmart"), GroceryStore(storeName: "Kroger"), GroceryStore(storeName: "Costco"), GroceryStore(storeName: "Sam's club"), GroceryStore(storeName: "The Home Depot")]))
}
