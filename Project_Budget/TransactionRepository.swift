import Foundation
import UIKit

class TransactionRepository{
    var transactions: [Transaction] = [
        Transaction(type: 0, cat: "Food", subCat: "Store", amount: 150, date: Date(), color: UIColor.blue),
        Transaction(type: 0, cat: "Sport", subCat: "Tennisgear", amount: 24, date: Date(), color: UIColor.red),
        Transaction(type: 0, cat: "Nightlife", subCat: "Drinks", amount: 30, date: Date(), color: UIColor.gray),
        Transaction(type: 1, cat: "Salary", subCat: "", amount: 1500, date: Date(), color: UIColor.green),
        Transaction(type: 1, cat: "Rent", subCat: "Appartment1", amount: 650, date: Date(), color: UIColor.orange)
    ]
    var expenses:[Transaction]
    var revenues: [Transaction]
    
    init(){
        self.expenses = transactions.filter {$0.type == .expense}
        self.revenues = transactions.filter {$0.type == .revenue}
    }
    func calcRepresentation(transaction: Transaction) -> Int{
        var total:Int
        if(transaction.type == .expense){
            total = expenses.reduce(0) { $0 + $1.amount }
        }
        else{
            total = revenues.reduce(0) { $0 + $1.amount }
        }
        let percent = Double(transaction.amount) / Double(total)
        return Int(percent*100)
    }
}
