import UIKit
import Charts
import RealmSwift

class PieChartController: UIViewController{
    @IBOutlet weak var pieChart: PieChartView!
    var model :CategoryRepository = CategoryRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateChartWithData()
    }
    private func updateChartWithData(){
        var dataEntries: [BarChartDataEntry] = []
        let expenses = model.expenses
        for i in 0..<expenses.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: model.getTotalAmount(of: expenses[i]))
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<expenses.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        pieChartDataSet.colors = colors
    }
}
