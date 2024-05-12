//
//  CustomListView.swift
//  MyFirstApp
//
//  Created by Long Sen on 5/3/24.
//

import SwiftUI

struct CustomListView<Item, Content>: View where Item: Hashable, Content: View {
    
    let items: [Item]
    let content: (Item) -> Content
    var tappedItem: ((Item) -> Void)?
    
    init(items: [Item], @ViewBuilder content: @escaping (Item) -> Content, tappedItem: ((Item) -> Void)?) {
        self.items = items
        self.content = content
        self.tappedItem = tappedItem
    }
    
    var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(items, id:\.self) { item in
                    content(item)
                        .onTapGesture {
                            tappedItem?(item)
                        }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).shadow(radius: 16).foregroundStyle(.white))
    }
}


