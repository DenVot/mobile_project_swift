import Foundation
import SwiftUI

struct Category: Identifiable, Hashable {
    let id: UUID
    var name: String
    var color: CategoryColor
    
    init(id: UUID = UUID(), name: String, color: CategoryColor = .blue) {
        self.id = id
        self.name = name
        self.color = color
    }
}

enum CategoryColor: String, CaseIterable {
    case green = "green"
    case purple = "purple"
    case blue = "blue"
    case orange = "orange"
    case red = "red"
    case yellow = "yellow"
    
    var swiftUIColor: Color {
        switch self {
        case .green:
            return Color(red: 0.7, green: 0.9, blue: 0.7)
        case .purple:
            return Color(red: 0.8, green: 0.7, blue: 0.9)
        case .blue:
            return .blue
        case .orange:
            return .orange
        case .red:
            return .red
        case .yellow:
            return .yellow
        }
    }
}

