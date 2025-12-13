import Foundation

class CategoryService: CategoryServiceProtocol {
    private let apiClient = APIClient.shared
    
    func getAllCategories() async throws -> [Category] {
        let categories: [Category] = try await apiClient.request(endpoint: "/categories", method: "GET")
        return categories
    }
    
    func getCategoryById(_ id: UUID) async throws -> Category? {
        do {
            let category: Category = try await apiClient.request(endpoint: "/categories/\(id.uuidString)", method: "GET")
            return category
        } catch APIError.serverError {
            return nil
        }
    }
    
    func createCategory(_ category: Category) async throws -> Category {
        let request = CreateCategoryRequest(name: category.name, color: category.color)
        let createdCategory: Category = try await apiClient.request(
            endpoint: "/categories",
            method: "POST",
            body: request
        )
        return createdCategory
    }
    
    func updateCategory(_ category: Category) async throws -> Category? {
        let request = CreateCategoryRequest(name: category.name, color: category.color)
        do {
            let updatedCategory: Category = try await apiClient.request(
                endpoint: "/categories/\(category.id.uuidString)",
                method: "PUT",
                body: request
            )
            return updatedCategory
        } catch APIError.serverError {
            return nil
        }
    }
    
    func deleteCategory(_ category: Category) async throws {
        let _: EmptyResponse = try await apiClient.request(
            endpoint: "/categories/\(category.id.uuidString)",
            method: "DELETE"
        )
    }
}
