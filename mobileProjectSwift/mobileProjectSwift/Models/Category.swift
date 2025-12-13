import Foundation
import SwiftUI

struct Category: Identifiable, Hashable, Codable, Equatable {
    let id: UUID
    var name: String
    var color: CategoryColor
    let userId: UUID?
    
    init(id: UUID = UUID(), name: String, color: CategoryColor = .blue, userId: UUID? = nil) {
        self.id = id
        self.name = name
        self.color = color
        self.userId = userId
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case userId
    }
}

enum CategoryColor: String, CaseIterable, Codable, Equatable {
    case green = "GREEN"
    case purple = "PURPLE"
    case blue = "BLUE"
    case orange = "ORANGE"
    case red = "RED"
    case yellow = "YELLOW"
    
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

