import Foundation
import UIKit


class Category{
    var type: TransactionType
    var name: String
    var subcategories :[Subcategory] = [Subcategory]()
    var color: UIColor
    
    init(type: Int, name: String, subcat: Subcategory, color: UIColor){
        self.type = TransactionType(rawValue: type)!
        self.name = name
        self.subcategories.append(subcat)
        self.color = color
    }
}
class Subcategory{
    var name: String
    var transactions: [Transaction] = [Transaction]()
    
    init(name: String, transaction: Transaction) {
        self.name = name
        self.transactions.append(transaction)
    }
}
class Transaction{
    var amount: Double
    var date: Date
    
    init(amount: Double, date: Date) {
        self.amount = amount
        self.date = date
    }
}
enum TransactionType: Int {
    case expense = 0
    case revenue = 1
}
