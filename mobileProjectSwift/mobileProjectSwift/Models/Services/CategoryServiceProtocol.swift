import Foundation

protocol CategoryServiceProtocol {
    func getAllCategories() async throws -> [Category]
    func getCategoryById(_ id: UUID) async throws -> Category?
    func createCategory(_ category: Category) async throws -> Category
    func updateCategory(_ category: Category) async throws -> Category?
    func deleteCategory(_ category: Category) async throws
}
