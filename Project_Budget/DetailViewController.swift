import UIKit

class DetailViewController: UITableViewController{
    
    var transaction: Transaction!
    var subcategories: [(String, [String])] = [("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"]),("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"]),("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"]),("Subcategory1", ["item1", "item2", "item3", "item4", "totaal:"])]
 
    override func viewDidLoad() {
        tableView.delegate = self
        title = transaction.category
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcategories[section].1.count
    }
    
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! CustomHeaderCell
//        cell.subcategoryName.text = subcategories[section].0
//        return cell
//    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != 0){
            return 40.0
        }
        return 0
    }
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! CustomFooterCell
//        cell.subcategoryName.text = subcategories[section].0
//        cell.subcategoryTotal.text = "€\(120)"
//        return cell
//    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 30
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == subcategories[indexPath.section].1.count-1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "footerCell") as! CustomFooterCell
            cell.subcategoryName.text = subcategories[indexPath.section].0
            cell.subcategoryTotal.text = "€\(120)"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
            cell.itemName.text = subcategories[indexPath.section].1[indexPath.row]
            cell.itemPrice.text = "€\(120)"
            return cell
        }
    }
    
}
