//
//  LocationRowView.swift
//  MyFirstApp
//
//  Created by Long Sen on 5/6/24.
//

import SwiftUI

struct LocationRowView: View {
    let location: Todo.Location
    
    var body: some View {
        HStack {
            Image(systemName: getImageSystemName())
            Text(location.getText())
        }
    }
    
    private func getImageSystemName() -> String {
        switch location {
        case .none:
            return "location.slash"
        case .current:
            return "location.circle.fill"
        case .getInCar:
            return "car"
        case .getOutCar:
            return "car.rear"
        case .grocery:
            return "storefront.circle.fill"
        case .custom:
            return "ellipsis"
        }
    }
}

#Preview {
    LocationRowView(location: .custom)
}
