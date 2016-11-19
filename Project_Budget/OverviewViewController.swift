import UIKit

class OverviewViewController: UITableViewController{
    
    private var model = TransactionRepository()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.transactions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "previewTransactionCell", for: indexPath) as! PreviewTransactionCell
        let transaction = model.transactions[indexPath.row]
        cell.categegoryName.text = "\(transaction.category)"
        cell.amount.text = "\(transaction.amount)"
        cell.color.backgroundColor = transaction.color
        return cell
    }
    /* Overriding this method triggers swipe actions (e.g. swipe to delete) */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            model.transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    @IBAction func unwindFromAdd(_ segue: UIStoryboardSegue){
        let source = segue.source as! AddViewController
        if let transaction = source.transaction{
            tableView.beginUpdates()
            model.transactions.append(transaction)
            tableView.insertRows(at: [IndexPath(row: model.transactions.count - 1, section: 0)], with: .automatic)
            tableView.endUpdates()
        }
    }
}
