import UIKit

class DetailViewController: UITableViewController{
    
    var category: Category!
    var model :CategoryRepository?
    let dateFormatter = DateFormatter()
    
    
    var subcategories: [(String, [String])] = [("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"]),("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"]),("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"]),("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"])]
 
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
        if(section != 0){
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
            cell.subcategoryTotal.text = "€\(model!.getTotalAmount(of: category.subcategories[indexPath.section]))"
            return cell
        }
            
        //InhoudCell
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
            cell.itemName.text = "\(dateFormatter.string(from: category.subcategories[indexPath.section].transactions[indexPath.row].date))"
            cell.itemPrice.text = "€\(category.subcategories[indexPath.section].transactions[indexPath.row].amount)"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if indexPath.row >= category.subcategories[indexPath.section].transactions.count {
                print("Delete hole subcat")
                model!.removeSubcategoryFromDb(category.subcategories[indexPath.section], of: category)
                category.subcategories.remove(at: indexPath.section)
                let indexSet = NSMutableIndexSet()
                indexSet.add(indexPath.section)
                tableView.deleteSections(indexSet as IndexSet, with: .automatic)
            }
            else {
                print("Delete one transaction")
                let transaction = category.subcategories[indexPath.section].transactions[indexPath.row]
                model!.removeTransactionFromDb(transaction, of: category.subcategories[indexPath.section], of: category)
                category.subcategories[indexPath.section].transactions.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
           
            tableView.endUpdates()
            
        }
    }
    
}
