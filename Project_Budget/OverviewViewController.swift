import UIKit

class OverviewViewController: UITableViewController{
    
    private var model = CategoryRepository()
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.rowHeight = 75
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "Expenses"
        }
        else{
            return "Revenues"
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return model.expenses.count
        }
        else{
            return model.revenues.count
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewTransactionCell", for: indexPath) as! PreviewTransactionCell
        var category:Category
        if(indexPath.section == 0){
            category = model.expenses[indexPath.row]
        }
        else{
            category = model.revenues[indexPath.row]
        }
        
        cell.categegoryName.text = "\(category.name)"
        cell.amount.text = "€ \(model.getTotalAmount(of: category))"
        cell.color.backgroundColor = UIColor().rgbToUIColor(category.color)
        let represenation = model.calcRepresentation(category: category)
        cell.representation.text = "Represens \(represenation)%"
        return cell
    }
    /* Overriding this method triggers swipe actions (e.g. swipe to delete) */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            model.expenses.remove(at: indexPath.row)
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
            let selectedIndex = tableView.indexPathForSelectedRow!.row
            if tableView.indexPathForSelectedRow?.section == 0 {
                destination.category = model.expenses[selectedIndex]
            }
            else {
                destination.category = model.revenues[selectedIndex]
            }
            
            
            print("Go to detailViewController")
        default:
            break
        }
    }
    
    @IBAction func unwindFromAdd1(_ segue: UIStoryboardSegue){
        let source = segue.source as! AddViewController
        if let category = source.category{
            tableView.beginUpdates()
            if(category.type == .expense){
                model.addCategory(category, of: .expense)
                tableView.insertRows(at: [IndexPath(row: model.expenses.count - 1, section: 0)], with: .automatic)
                tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
            else{
                model.addCategory(category, of: .revenue)
                tableView.insertRows(at: [IndexPath(row: model.revenues.count - 1, section: 1)], with: .automatic)
                tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }

            tableView.endUpdates()
        }
    }
    @IBAction func unwindFrommDetail1(_ segue: UIStoryboardSegue){
        
    }
}
