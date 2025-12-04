import SwiftUI

struct CategoriesView: View {
    @ObservedObject var expenseService: ExpenseService
    @State private var showAddCategory = false
    
    var body: some View {
        ZStack {
            List {
                ForEach(expenseService.categories) { category in
                    HStack {
                        Circle()
                            .fill(category.color.swiftUIColor)
                            .frame(width: 20, height: 20)
                        
                        Text(category.name)
                            .font(.body)
                        
                        Spacer()
                        
                        Button {
                            expenseService.deleteCategory(category)
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showAddCategory = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationTitle("Категории")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddCategory) {
            AddCategoryView(expenseService: expenseService)
        }
    }
}

#Preview {
    NavigationStack {
        CategoriesView(expenseService: ExpenseService())
    }
}

