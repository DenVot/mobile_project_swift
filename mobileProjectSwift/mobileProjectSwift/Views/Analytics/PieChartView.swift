import SwiftUI

struct PieChartView: View {
    let categoryExpenses: [(category: Category, amount: Double, percentage: Double)]
    
    var body: some View {
        GeometryReader { geometry in
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = min(geometry.size.width, geometry.size.height) / 2
            
            ZStack {
                ForEach(Array(categoryExpenses.enumerated()), id: \.offset) { index, item in
                    let startAngle = getStartAngle(for: index)
                    let endAngle = getEndAngle(for: index)
                    
                    Path { path in
                        path.move(to: center)
                        path.addArc(
                            center: center,
                            radius: radius,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: false
                        )
                        path.closeSubpath()
                    }
                    .fill(item.category.color.swiftUIColor)
                }
            }
        }
    }
    
    private func getStartAngle(for index: Int) -> Angle {
        var startAngle: Double = -90
        for i in 0..<index {
            let percentage = categoryExpenses[i].percentage
            startAngle += (percentage / 100) * 360
        }
        return Angle(degrees: startAngle)
    }
    
    private func getEndAngle(for index: Int) -> Angle {
        var endAngle: Double = -90
        for i in 0...index {
            let percentage = categoryExpenses[i].percentage
            endAngle += (percentage / 100) * 360
        }
        return Angle(degrees: endAngle)
    }
}

#Preview {
    PieChartView(categoryExpenses: [])
    .frame(width: 300, height: 300)
}

