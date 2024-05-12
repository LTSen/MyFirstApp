//
//  BarProgressStyle.swift
//  MyFirstApp
//
//  Created by Long Sen on 3/13/24.
//

import SwiftUI

struct CustomProgressView: View {
    var isFinished: Bool
    var isCornerRadius: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: isCornerRadius ? 10: 0)
                        .frame(width: geometry.size.width, height: geometry.size.height)
//                        .frame(width: size.width, height: size.height)

                        .foregroundColor(.white)
                    RoundedRectangle(cornerRadius: isCornerRadius ? 10: 0)
                        .frame(width: isFinished ? geometry.size.width : 0, height: geometry.size.height)
//                        .frame(width: isFinished ? size.width : 0, height: size.height)

                        .foregroundColor(isFinished ? .green.opacity(0.3) : .white)
                }
            }
        }
    }
}

#Preview {
    CustomProgressView(isFinished: true)
}
