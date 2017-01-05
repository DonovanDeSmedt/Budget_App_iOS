import UIKit
import Charts
import RealmSwift

class PieChartController: UIViewController{
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var prevMonth: UIButton!
    @IBOutlet weak var nextMonth: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var monthText: UILabel!
    
    private var currentType: TransactionType = .expense
    private var currentMonth :(String, Int, Int)?
    private var model :CategoryRepository = CategoryRepository.repositoryInstance
    
    @IBAction func onChangeType(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            currentType = .expense
        case 1:
            currentType = .revenue
        default:
            break;
        }
        let data = currentType == .expense ? model.expenses : model.revenues
        updateChartWithData(data)
    }
    
    @IBAction func onChangeMonth(_ sender: UIButton) {

        let currentDate = Date().from(year: currentMonth!.2, month: currentMonth!.1, day: 1)
        if sender == nextMonth {
            let next = currentDate.getNextMonth()
            currentMonth = (next.0, next.1, next.2)
        }
        else if sender == prevMonth{
            let next = currentDate.getPreviousMonth()
            currentMonth = (next.0, next.1, next.2)
            
        }
        model.filterCategories(month: currentMonth!.1, year: currentMonth!.2)
        let data = currentType == .expense ? model.expenses : model.revenues
        updateChartWithData(data)
        updateHeader()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        initializeElements()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeElements()
    }
    private func initializeElements(){
        currentMonth = (Date().getMonthName(), Date().getMonthNumber(), Date().getYear())
        model.filterCategories(month: currentMonth!.1, year: currentMonth!.2)
        updateChartWithData(model.expenses)
        updateHeader()
    }
    private func updateChartWithData(_ data: [Category]){
        var dataEntries: [PieChartDataEntry] = []
        for i in 0..<data.count {
            let dataEntry = PieChartDataEntry(value: Double(model.calcRepresentation(category: data[i]).value), label: data[i].name)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Percentage of \(currentType)s per category for \(currentMonth!.0)")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChart.data = pieChartData
        pieChart.chartDescription?.enabled = false
        
        var colors: [UIColor] = []
        
        for _ in 0..<data.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        pieChartDataSet.colors = colors
    }
    private func updateHeader(){
        monthText.text = "\(currentMonth!.0) \(currentMonth!.2)"
    }
}
