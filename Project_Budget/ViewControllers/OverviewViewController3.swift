import UIKit


class OverviewViewController3: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var overview: UITableView!
    @IBOutlet weak var footer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var btnPreviousMonth: UIButton!
    @IBOutlet weak var btnNextMonth: UIButton!
    @IBOutlet weak var monthText: UILabel!
    
    
    @IBOutlet weak var totalExpensesText: UILabel!
    @IBOutlet weak var totalRevenuesText: UILabel!
    
    private var model = CategoryRepository.repositoryInstance
    private var currentType : TransactionType = TransactionType.expense
    private var currentMonth :(String, Int, Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overview.delegate = self
        overview.dataSource = self
        currentMonth = (Date().getMonthName(), Date().getMonthNumber(), Date().getYear())
        updateFooter()
        updateHeader()
        model.filterCategories(month: currentMonth!.1, year: currentMonth!.2)
        
    }
    
    
    
    
    @IBAction func OnChangeType(_ sender: UISegmentedControl) {
        
        switch segmentControl.selectedSegmentIndex
        {
        case 0:
            currentType = .expense
        case 1:
            currentType = .revenue
        default:
            break;
        }
        overview.reloadData()
    }
    
    private func updateHeader(){
        monthText.text = "\(currentMonth!.0) \(currentMonth!.2)"
    }
    private func updateFooter() {
        totalExpensesText.text = " \(model.getTotalExpenses())"
        totalRevenuesText.text = "\(model.getTotalRevenues())"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func viewWillAppear(_ animated: Bool) {
        overview.rowHeight = 95
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentType == .expense ?
            model.expenses.filter{$0.subcategories.count != 0}.count :
            model.revenues.filter{$0.subcategories.count != 0}.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewTransactionCell", for: indexPath) as! PreviewTransactionCell
        var category:Category
        
        category = currentType == .expense ? model.expenses[indexPath.row] : model.revenues[indexPath.row]
        
        cell.categegoryName.text = "\(category.name)"
        cell.amount.text = "€ \(model.getTotalAmount(of: category))"
        let represenation = model.calcRepresentation(category: category)
        cell.representation.text = "Represents \(represenation.value)%"
        //cell.progressView.transform = cell.progressView.transform.scaledBy(x: 1, y: 10)
        cell.progressView.setProgress(Float(represenation.percent), animated: false)
        cell.progressView.progressTintColor = UIColor().rgbToUIColor(category.color)
        return cell
    }
    /* Overriding this method triggers swipe actions (e.g. swipe to delete) */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if currentType == .expense {
                model.removeCategoryFromDb(model.expenses[indexPath.row], month: currentMonth!.1)
                model.expenses.remove(at: indexPath.row)
                
            }
            else {
                model.removeCategoryFromDb(model.revenues[indexPath.row], month: currentMonth!.1)
                model.revenues.remove(at: indexPath.row)
            }
            updateFooter()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "add":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.topViewController as! AddViewController
            destination.categoryRepository = model
            print("Go to addViewController")
            
        case "detail":
            let navigationController = segue.destination as! UINavigationController
            let destination = navigationController.topViewController as! DetailViewController
            let selectedIndex = overview.indexPathForSelectedRow!.row
            destination.category = currentType == .expense ? model.expenses[selectedIndex] : model.revenues[selectedIndex]
            destination.model = model
            print("Go to detailViewController")
        default:
            break
        }
    }
    
    
    @IBAction func unwindFromAdd(_ segue: UIStoryboardSegue){
        let source = segue.source as! AddViewController
        if let category = source.category{
            overview.beginUpdates()
            if(category.type == .expense){
                model.addCategory(category, of: .expense)
            }
            else{
                model.addCategory(category, of: .revenue)
            }
            overview.endUpdates()
            model.filterCategories(month: currentMonth!.1, year: currentMonth!.2)
            updateFooter()
            overview.reloadData()
        }
    }
    @IBAction func unwindFrommDetail(_ segue: UIStoryboardSegue){
        updateFooter()
        overview.reloadData()
        print("Detail")
    }
    
    @IBAction func changeMonth(_ sender: UIButton){
        let currentDate = Date().from(year: currentMonth!.2, month: currentMonth!.1, day: 1)
        if sender == btnNextMonth {
            let next = currentDate.getNextMonth()
            currentMonth = (next.0, next.1, next.2)
        }
        else if sender == btnPreviousMonth{
            let next = currentDate.getPreviousMonth()
            currentMonth = (next.0, next.1, next.2)
           
        }
        model.filterCategories(month: currentMonth!.1, year: currentMonth!.2)
        overview.reloadData()
        updateHeader()
        updateFooter()
    }
    private func filterData() {
        
    }
    
}

