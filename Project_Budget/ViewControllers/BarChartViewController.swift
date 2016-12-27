import UIKit
import Charts
import RealmSwift

class BarCharViewController: UIViewController {
    
    @IBOutlet weak var barView: BarChartView!
    var model :CategoryRepository = CategoryRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCharWithData()
    }
    private func updateCharWithData(){
        var dataEntries: [BarChartDataEntry] = []
        let expenses = model.expenses
        for i in 0..<expenses.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(expenses[i].subcategories.count))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Subcategory count")
        let chartData = BarChartData(dataSet: chartDataSet)
        barView.data = chartData
    }
}
