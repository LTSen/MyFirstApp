//
//  Grid.swift
//  MyFirstApp
//
//  Created by Long Sen on 5/12/24.
//

import SwiftUI

struct Grid<Item, ID, ItemView>: View where ID: Hashable, ItemView: View {
    
    private var gridColumns: Int
    private var items: [(String, [Item])]
    private var id: KeyPath<(String, [Item]), ID>
    private var viewForItem: ((String, [Item])) -> ItemView
    
    init(gridColumns: Int, items: [(String, [Item])], id: KeyPath<(String, [Item]), ID>, viewForItem: @escaping ((String, [Item])) -> ItemView) {
        self.gridColumns = gridColumns
        self.items = items
        self.id = id
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(columnsCount: gridColumns, gridWidth: geometry.size.width, itemRows: items.map {$0.1.count}))
        }
    }
    
    private func body(for layout: GridLayout) -> some View {
        return ForEach(items, id: id) { item in
            self.body(for: item, in: layout)
        }
    }
    
    private func body(for item: (String, [Item]), in layout: GridLayout) -> some View {
        return Group {
            if let index = items.firstIndex(where: { item[keyPath: id] == $0[keyPath: id ]}) {
                viewForItem(item)
                    .frame(width: layout.itemSize(of: index).width, height: layout.itemSize(of: index).height)
                    .position(layout.location(of: index))
            }
        }
    }
}
