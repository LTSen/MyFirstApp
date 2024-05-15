//
//  GridLayout.swift
//  MyFirstApp
//
//  Created by Long Sen on 5/12/24.
//

import SwiftUI

struct GridLayout {
    var columnsCount: Int = 1
    var gridWidth: CGFloat
    var itemRows: [Int]
    let rowHeight: CGFloat = 35
    var itemSize: [CGSize] = []
    var itemLocation: [CGPoint] = []
    let padding: CGFloat = 8
    
    init(columnsCount: Int, gridWidth: CGFloat, itemRows: [Int]) {
        self.columnsCount = columnsCount
        self.gridWidth = gridWidth
        self.itemRows = itemRows
        var totalLeftHeight: CGFloat = 0
        var totalRightHeight: CGFloat = 0
        let itemWidth = (gridWidth - CGFloat(columnsCount - 1) * padding) / CGFloat(columnsCount)
        for index in itemRows.indices {
            let itemHeight = getItemHeight(index: index)
            if totalLeftHeight <= totalRightHeight {
                itemLocation.append(getLocation(isLeft: true, currentHeight: totalLeftHeight, itemWidth: itemWidth, itemHeight: itemHeight))
                totalLeftHeight += itemHeight
                totalLeftHeight += padding
            } else {
                itemLocation.append(getLocation(isLeft: false, currentHeight: totalRightHeight, itemWidth: itemWidth, itemHeight: itemHeight))
                totalRightHeight += itemHeight
                totalRightHeight += padding
            }
            itemSize.append(CGSize(width: itemWidth, height: itemHeight))
        }
    }
    
    private func getItemHeight(index: Int) -> CGFloat {
        guard index < itemRows.count else { return 0 }
        return rowHeight * CGFloat(itemRows[index] + 1) + padding * 2.0
    }
    
    private func getLocation(isLeft: Bool, currentHeight: CGFloat, itemWidth: CGFloat, itemHeight: CGFloat) -> CGPoint {
        let x = isLeft ? itemWidth / 2 : itemWidth + (itemWidth / 2) + padding
        let y = (currentHeight + itemHeight) / 2
        return CGPoint(x: x, y: y)
    }
    
    func location(of index: Int) -> CGPoint {
        guard index < itemLocation.count else { return CGPoint() }
        return itemLocation[index]
    }
    
    func itemSize(of index: Int) -> CGSize {
        guard index < itemSize.count else { return CGSize() }
        return itemSize[index]
    }
}
