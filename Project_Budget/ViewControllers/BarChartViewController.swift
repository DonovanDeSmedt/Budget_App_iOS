import UIKit
import Charts
import RealmSwift

class BarCharViewController: UIViewController{
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var barView: BarChartView!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    private var model :CategoryRepository = CategoryRepository.repositoryInstance
    private var currentType : TransactionType = TransactionType.expense

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (segmentControl.subviews[0] as UIView).tintColor = Style.sectionHeaderBackgroundColor
        (segmentControl.subviews[1] as UIView).tintColor = Style.sectionHeaderBackgroundColor
        let data = currentType == .expense ? model.expenses : model.revenues
        updateCharWithData(data)
    }
    override func viewWillAppear(_ animated: Bool) {
        model.readDb()
        let data = currentType == .expense ? model.expenses : model.revenues
        segmentControl.selectedSegmentIndex = currentType == .expense ? 0 : 1
        updateCharWithData(data)
    }
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
        updateHeader()
        let data = currentType == .expense ? model.expenses : model.revenues
        updateCharWithData(data)
    }
    private func updateHeader(){
        lblTotalAmount.text = "€ \(model.calcTotalAmount(of: currentType))"
        if currentType == .expense {
            lblTotalAmount.textColor = UIColor.red
        }
        else if currentType == .revenue {
            lblTotalAmount.textColor = Style.sectionHeaderBackgroundColor
        }
        lblTotalTitle.text = "Total annual \(currentType)s"
    }
    private func updateCharWithData(_ data: [Category]){
        updateHeader()
        
        let formatter = BarChartFormatter()
        let xaxis:XAxis = XAxis()
        
        let names = data.map {String($0.name)!}
        formatter.setValues(values: names)
        
        
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<data.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(model.calcRepresentation(category: data[i]).value))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Percentage of \(currentType)s per category")
        
        var colors: [UIColor] = []
        
        for var category in data {
            colors.append(UIColor().rgbToUIColor(category.color))
        }
        
        chartDataSet.colors = colors
        
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        xaxis.valueFormatter = formatter
        barView.xAxis.labelPosition = .bottom
         barView.xAxis.valueFormatter = xaxis.valueFormatter
        barView.chartDescription?.enabled = false
        barView.legend.enabled = false
        barView.leftAxis.axisMinimum = 0.0
        barView.leftAxis.axisMaximum = 100.0
        barView.rightAxis.enabled = false
        barView.data = chartData
        
        barView.xAxis.granularityEnabled = true
        barView.xAxis.granularity = 1.0 //default granularity is 1.0, but it is better to be explicit
        barView.xAxis.decimals = 0
    }
}
