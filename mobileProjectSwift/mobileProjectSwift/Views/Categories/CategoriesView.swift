import SwiftUI

struct CategoriesView: View {
    @ObservedObject var expenseViewModel: ExpenseViewModel
    @State private var showAddCategory = false
    
    var body: some View {
        ZStack {
            List {
                ForEach(expenseViewModel.categories) { category in
                    HStack {
                        Circle()
                            .fill(category.color.swiftUIColor)
                            .frame(width: 20, height: 20)
                        
                        Text(category.name)
                            .font(.body)
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await MainActor.run {
                                    expenseViewModel.deleteCategory(category)
                                }
                                await MainActor.run {
                                    expenseViewModel.loadData()
                                }
                            }
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
        .sheet(isPresented: $showAddCategory) {
            AddCategoryView(expenseViewModel: expenseViewModel)
        }
        .onAppear {
            if expenseViewModel.categories.isEmpty {
                expenseViewModel.loadData()
            }
        }
    }
}

#Preview {
    let expenseService = ExpenseService()
    let expenseViewModel = ExpenseViewModel(expenseService: expenseService)
    return NavigationStack {
        CategoriesView(expenseViewModel: expenseViewModel)
    }
}

