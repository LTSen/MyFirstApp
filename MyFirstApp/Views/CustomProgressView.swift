//
//  BarProgressStyle.swift
//  MyFirstApp
//
//  Created by Long Sen on 3/13/24.
//

import SwiftUI

struct CustomProgressView: ViewModifier {
    
    var isFinished: Bool
    var isCornerRadius: Bool = false
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                VStack {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: isCornerRadius ? 10: 0)
                            .foregroundColor(.white)
                        RoundedRectangle(cornerRadius: isCornerRadius ? 10: 0)
                            .frame(width: isFinished ? geometry.size.width : 0)
                            .foregroundColor(isFinished ? .green.opacity(0.3) : .white)
                    }
                }
            }
            content
        }
    }
}

extension View {
    func addProgessView(isFinished: Bool, isCornerRadius: Bool = false) -> some View {
        self.modifier(CustomProgressView(isFinished: isFinished, isCornerRadius: isCornerRadius))
    }
}



#Preview {
    Text("Hello")
    .addProgessView(isFinished: true, isCornerRadius: true)
}
