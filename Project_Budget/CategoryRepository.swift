import Foundation
import UIKit

class CategoryRepository{
    
    
    var categories: [Category] = [
        Category(type: 0, name: "Food", subcat: Subcategory(name: "Store", transaction: Transaction(amount: 150, date: Date())), color: UIColor.blue),
        Category(type: 0, name: "Sport", subcat: Subcategory(name: "Tennisgear", transaction: Transaction(amount: 24, date: Date())), color: UIColor.green),
        Category(type: 0, name: "Nightlife", subcat: Subcategory(name: "Drinks", transaction: Transaction(amount: 55, date: Date())), color: UIColor.red),
        Category(type: 1, name: "Salary", subcat: Subcategory(name: "", transaction: Transaction(amount: 1500, date: Date())), color: UIColor.orange),
        Category(type: 1, name: "Intrest", subcat: Subcategory(name: "Appartment 1", transaction: Transaction(amount: 650, date: Date())), color: UIColor.yellow)
    ]
//        [
//        Transaction(type: 0, cat: "Food", subCat: "Store", amount: 150, date: Date(), color: UIColor.blue),
//        Transaction(type: 0, cat: "Sport", subCat: "Tennisgear", amount: 24, date: Date(), color: UIColor.red),
//        Transaction(type: 0, cat: "Nightlife", subCat: "Drinks", amount: 30, date: Date(), color: UIColor.gray),
//        Transaction(type: 1, cat: "Salary", subCat: "", amount: 1500, date: Date(), color: UIColor.green),
//        Transaction(type: 1, cat: "Rent", subCat: "Appartment1", amount: 650, date: Date(), color: UIColor.orange)
//    ]
    var expenses:[Category]
    var revenues: [Category]
    
    init(){
        self.expenses = categories.filter {$0.type == .expense}
        self.revenues = categories.filter {$0.type == .revenue}
    }
    func calcRepresentation(category: Category) -> Int{
        var total:Double
        if(category.type == .expense){
            total = expenses.reduce(0) { $0 + $1.subcategories.reduce(0) {$0 + $1.transactions.reduce(0) {$0 + $1.amount} } }
        }
        else{
            total = revenues.reduce(0) { $0 + $1.subcategories.reduce(0) {$0 + $1.transactions.reduce(0) {$0 + $1.amount} } }
        }
        let percent = Double(category.subcategories.reduce(0) {$0 + $1.transactions.reduce(0) {$0 + $1.amount}}) / Double(total)
        return Int(percent*100)
    }
    func getTotalAmount(of category: Category) -> Double{
        return category.subcategories.reduce(0) {$0 + $1.transactions.reduce(0) {$0 + $1.amount} }
    }
    func getCategory(with name: String) -> Category{
        return categories.filter {$0.name == name}.first!
    }
    func getSubCategory(with name: String, of category: Category) -> Subcategory{
        return getCategory(with: category.name).subcategories.filter {$0.name == name}.first!
    }
}
