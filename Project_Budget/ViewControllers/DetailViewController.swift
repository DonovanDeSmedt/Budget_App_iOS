import UIKit

class DetailViewController: UITableViewController{
    
    var category: Category!
    var model :CategoryRepository?
    let dateFormatter = DateFormatter()
    var currentMonth :(String, Int, Int)?

 
    override func viewDidLoad() {
        tableView.delegate = self
        title = category.name
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return category.subcategories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if category.subcategories[section].transactions.count == 0 {
            return 0
        }
        return category.subcategories[section].transactions.count + 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 40.0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        //Footercell
        if indexPath.row == (category.subcategories[indexPath.section].transactions.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! CustomFooterCell
            cell.subcategoryName.text = category.subcategories[indexPath.section].name
            cell.subcategoryTotal.text = "€\(Int(model!.getTotalAmount(of: category.subcategories[indexPath.section])))"
            return cell
        }
            
        //ContentCell
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
            cell.itemName.text = "\(dateFormatter.string(from: category.subcategories[indexPath.section].transactions[indexPath.row].date))"
            cell.itemPrice.text = "€\(Int(category.subcategories[indexPath.section].transactions[indexPath.row].amount))"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let indexSet = NSMutableIndexSet()
            indexSet.add(indexPath.section)
            //Delete complete subcategory
            if indexPath.row >= category.subcategories[indexPath.section].transactions.count {
                model!.removeSubcategoryFromDb(category.subcategories[indexPath.section], of: category, month: currentMonth!.1)
                category.subcategories.remove(at: indexPath.section)
                tableView.deleteSections(indexSet as IndexSet, with: .automatic)
            }
            //Delete one transaction
            else {
                let transaction = category.subcategories[indexPath.section].transactions[indexPath.row]
                model!.removeTransactionFromDb(transaction, of: category.subcategories[indexPath.section], of: category)
                category.subcategories[indexPath.section].transactions.remove(at: indexPath.row)
                if category.subcategories[indexPath.section].transactions.count == 0 {
                    tableView.deleteSections(indexSet as IndexSet, with: .automatic)
                    category.subcategories.remove(at: indexPath.section)
                }
                else{
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
            tableView.endUpdates()
            tableView.reloadData()
        }
    }
    
}
