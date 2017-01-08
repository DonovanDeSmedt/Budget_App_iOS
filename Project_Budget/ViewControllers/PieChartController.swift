import UIKit
import Charts
import RealmSwift

class PieChartController: UIViewController{
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var prevMonth: UIButton!
    @IBOutlet weak var nextMonth: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var monthText: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
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
        updateHeaderMonth()
    }

    override func viewWillAppear(_ animated: Bool) {
        initializeElements()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        (segmentControl.subviews[0] as UIView).tintColor = Style.sectionHeaderBackgroundColor
        (segmentControl.subviews[1] as UIView).tintColor = Style.sectionHeaderBackgroundColor
        initializeElements()
    }
    private func initializeElements(){
        currentMonth = (Date().getMonthName(), Date().getMonthNumber(), Date().getYear())
        model.filterCategories(month: currentMonth!.1, year: currentMonth!.2)
        updateChartWithData(model.expenses)
        updateHeaderMonth()
    }
    private func updateChartWithData(_ data: [Category]){
        updateHeaderTotal()
        
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
        
        for var category in data {
            colors.append(UIColor().rgbToUIColor(category.color))
        }
        pieChart.chartDescription?.enabled = false
        pieChart.legend.enabled = false
        pieChartDataSet.colors = colors
    }
    private func updateHeaderMonth(){
        monthText.text = "\(currentMonth!.0) \(currentMonth!.2)"
    }
    private func updateHeaderTotal(){
        lblTotalTitle.text = "Total monthly \(currentType)s"
        if currentType == .expense {
            lblTotalAmount.textColor = UIColor.red
        }
        else{
            lblTotalAmount.textColor = Style.sectionHeaderBackgroundColor
        }
        lblTotalAmount.text = "€ \(model.calcTotalAmount(of: currentType))"
    }
}
