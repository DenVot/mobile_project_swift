import Foundation

struct CreateCategoryRequest: Codable {
    let name: String
    let color: CategoryColor
}
