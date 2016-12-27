import Foundation
import UIKit
import Realm
import RealmSwift


class CategoryRepository{
    
    
    var categories: [Category] = []
    
    var expenses:[Category]
    var revenues: [Category]
    
    init(){
        self.expenses = categories.filter {$0.type == .expense}
        self.revenues = categories.filter {$0.type == .revenue}
        // seedDb()
        // deleteDb()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        readDb()
    }
    
    /*
     * DATABASE FUNCTIONS
     */
    func seedDb() {
        let transaction1 = Transaction()
        transaction1.date = Date()
        transaction1.amount = 150
        
        let transaction2 = Transaction()
        transaction2.date = Date()
        transaction2.amount = 75
        
        let transaction3 = Transaction()
        transaction3.date = Date()
        transaction3.amount = 1600
        
        let subCatFood = Subcategory()
        subCatFood.name = "Store"
        subCatFood.transactions.append(transaction1)
        subCatFood.transactions.append(transaction2)
        
        let subCatFood2 = Subcategory()
        subCatFood2.name = "Restaurant"
        subCatFood2.transactions.append(transaction2)
        
        let subCatSalary = Subcategory()
        subCatSalary.name = "Salary"
        subCatSalary.transactions.append(transaction3)
        
        
        let foodCat = Category()
        foodCat.type = .expense
        foodCat.name = "Food"
        foodCat.subcategories.append(subCatFood)
        foodCat.subcategories.append(subCatFood2)
        foodCat.color = UIColor.blue.rgb()!
        
        
        
        let salaryCat = Category()
        salaryCat.type = .revenue
        salaryCat.name = "Salary"
        salaryCat.subcategories.append(subCatSalary)
        salaryCat.color = UIColor.green.rgb()!
        
        
        categories.append(foodCat)
        categories.append(salaryCat)
        do {
            let realm = try Realm()
            try realm.write {
                for category in categories {
                    realm.add(category, update: false)
                }
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func readDb() {
        do {
            let realm = try Realm()
            let cats = realm.objects(Category.self)
            self.categories = Array(cats)
            self.expenses = categories.filter {$0.type == .expense}
            self.revenues = categories.filter {$0.type == .revenue}
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteDb() {
        do {
            let realm = try Realm()
            try! realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func addObjectDb(category: Category, update: Bool) {
        do {
            let realm = try Realm()
            realm.add(category, update: update)
            
        } catch let error as NSError{
            fatalError(error.localizedDescription)
        }
    }
    func updateObjectDb(category: Category){
        //objecten zoeken en updaten
        let originalObject = categories.filter {$0.name == category.name && $0.type == category.type}.first!
        originalObject.subcategories = category.subcategories
    }
    func removeCategoryFromDb(_ category: Category){
        let index = categories.index(of: category)!
        var originalObject = categories[index]
        
        //Delete category and it's child objects from the db
        for var subcategory in originalObject.subcategories{
            for var transaction in subcategory.transactions {
                removeObjectFromDb(&transaction)
            }
            removeObjectFromDb(&subcategory)
        }
        removeObjectFromDb(&originalObject)
        
        //Delete the object from the local list
        categories.remove(at: index)
    }
    func removeSubcategoryFromDb(_ subcategory: Subcategory, of category: Category){
        //Find original category object
        let originalObject = categories.filter {$0.name == category.name && $0.type == category.type}.first!
        let index = originalObject.subcategories.index(where: {$0.name == subcategory.name})!
        
        //Remove from local list
        var originalSubcat :Subcategory?
        
        //Delete subcategory from local list
        do {
            let realm = try Realm()
            try! realm.write {
                originalSubcat = originalObject.subcategories.remove(at: index)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        
        
        //Delete subcategory and its transactions from db
        for var transaction in originalSubcat!.transactions {
            removeObjectFromDb(&transaction)
        }
        removeObjectFromDb(&originalSubcat)
    }
    func removeTransactionFromDb(_ transaction: Transaction, of subcategory: Subcategory, of category: Category){
        //Find original category object
        let originalCat = categories.filter {$0.name == category.name && $0.type == category.type}.first!
        
        //Find original subcategory object
        let originalSubcat = originalCat.subcategories.filter{$0.name == subcategory.name}.first!
        
        //Find index transaction object
        let index = originalSubcat.transactions.index(where: {$0.date == transaction.date})!
        
        var originalTransaction :Transaction?
        
        //Delete transaction from local list
        do {
            let realm = try Realm()
            try! realm.write {
                originalTransaction = originalSubcat.transactions.remove(at: index)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
        //Delete transaction from db
        removeObjectFromDb(&originalTransaction)
    
    }
    private func removeObjectFromDb<E>(_ object: inout E){
        do {
            let realm = try Realm()
            try! realm.write {
                realm.delete(object as! Object)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    /*
     * CATEGORY FUNCTIONS
     */
    func filterCategories(month: Int, year: Int){
        var newList :[Category] = [Category]()
        let result = categories.filter { (cat) in
            let newCat = Category()
            newCat.name = cat.name
            newCat.color = cat.color
            newCat.type = cat.type
            
            let subcatList = cat.subcategories.filter { (subcat) in
                let newSubcat = Subcategory()
                newSubcat.name = subcat.name
                
                let transactionList = subcat.transactions.filter {$0.date.getMonthNumber() == month && $0.date.getYear() == year}
                
                let tussenLijst = List<Transaction>(transactionList)
                newSubcat.transactions = tussenLijst
                
                if transactionList.count > 0 && !newCat.subcategories.contains(newSubcat){
                    newCat.subcategories.append(newSubcat)
                }
                
                
                return transactionList.count > 0
            }
            if(subcatList.count > 0){
                newList.append(newCat)
            }
            
            return subcatList.count > 0
        }
        
        self.expenses = newList.filter {$0.type == .expense}
        self.revenues = newList.filter {$0.type == .revenue}
    }
    func calcRepresentation(category: Category) -> (percent: Double, value: Int){
        var total:Double
        if(category.type == .expense){
            total = getTotalExpenses()
        }
        else{
            total = getTotalRevenues()
        }
        if total == 0 {
            return (percent: 0.0, value: 0)
        }
        let percent = Double(category.subcategories.reduce(0) {$0 + $1.transactions.reduce(0) {$0 + $1.amount}}) / Double(total)
        return (percent: percent, value: Int(percent*100))
    }
    
    
    func getTotalAmount(of category: Category) -> Double{
        return category.subcategories.reduce(0) {$0 + $1.transactions.reduce(0) {$0 + $1.amount} }
    }
    func getTotalAmount(of subcategory: Subcategory) -> Double{
        return subcategory.transactions.reduce(0) {$0 + $1.amount}
    }
    func getTotalExpenses() -> Double{
        return expenses.reduce(0) { $0 + $1.subcategories.reduce(0) {$0 + $1.transactions.reduce(0) {$0 + $1.amount} } }
    }
    func getTotalRevenues() -> Double {
        return revenues.reduce(0) { $0 + $1.subcategories.reduce(0) {$0 + $1.transactions.reduce(0) {$0 + $1.amount} } }
    }
    
    
    func getCategory(with name: String, of type: TransactionType) -> Category{
        return categories.filter {$0.name.lowercased() == name && $0.type == type}.first!
    }
    
    func getSubCategory(with name: String, of category: Category, with type: TransactionType) -> Subcategory{
        return getCategory(with: category.name.lowercased(),of: type).subcategories.filter {$0.name.lowercased() == name}.first!
    }
    
    func categoryExist(with name: String, of type: TransactionType) -> Bool{
        switch type {
        case .expense:
            return expenses.filter({$0.name.lowercased() == name}).first != nil
        case .revenue:
            return revenues.filter({$0.name.lowercased() == name}).first != nil
        }
    }
    
    func subCategoryExist(of category: Category, with name: String) -> Bool {
        return category.subcategories.filter({$0.name.lowercased() == name}).first != nil
    }
    
    
    func addCategory(_ category: Category, of type: TransactionType){
        var isUpdate = false
        if let index = categories.index(where: ({$0.name == category.name && $0.type == type})){
            isUpdate = index > -1
            categories.add(category: category, replace: isUpdate, index: index)
        }
        else{
            categories.add(category: category, replace: false, index: 0)
        }
        
    }
    
    
}


