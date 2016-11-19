import Foundation
import UIKit


class Transaction{
    var type: TransactionType
    var amount: Int
    var category: String
    var subCategory: String
    var date: Date
    var color: UIColor
    
    init(type: Int, cat: String, subCat: String, amount: Int, date: Date, color: UIColor){
        self.type = TransactionType(rawValue: type)!
        self.category = cat
        self.subCategory = subCat
        self.amount = amount
        self.date = date
        self.color = color
    }
}
enum TransactionType: Int {
    case expense = 0
    case revenue = 1
}
