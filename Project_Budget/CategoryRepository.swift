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
        //seedDb()
        //deleteDb()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        readDb()
        
    }
    
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
                    print(category.type)
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
    
    func updateObjectDb(category: Category, update: Bool) {
        do {
            let realm = try Realm()
            try! realm.write {
                realm.add(category, update: update)
            }
        } catch let error as NSError{
            fatalError(error.localizedDescription)
        }
        
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
    
    func getCategory(with name: String, of type: TransactionType) -> Category{
        switch type {
        case .expense:
            return expenses.filter {$0.name == name}.first!
        case .revenue:
            return revenues.filter {$0.name == name}.first!
        }
    }
    
    func getSubCategory(with name: String, of category: Category, with type: TransactionType) -> Subcategory{
        return getCategory(with: category.name,of: type).subcategories.filter {$0.name == name}.first!
    }
    
    func categoryExist(with name: String, of type: TransactionType) -> Bool{
        switch type {
        case .expense:
           return expenses.filter({$0.name == name}).first != nil
        case .revenue:
            return revenues.filter({$0.name == name}).first != nil
        }
    }
    
    func subCategoryExist(of category: Category, with name: String) -> Bool {
        return category.subcategories.filter({$0.name == name}).first != nil
    }
    
    
    func addCategory(_ category: Category, of type: TransactionType){
        var isUpdate = false
        //If category exist replace with newly formed categoryObject, otherwise append new categoryObject
        switch type {
        case .expense:
            if let index = expenses.index(where: ({$0.name == category.name})){
                isUpdate = index > -1
                expenses.add(category: category, replace: isUpdate, index: index)
            }
            else{
                expenses.add(category: category, replace: false, index: 0)
            }
        case .revenue:
            if let index = revenues.index(where: ({$0.name == category.name})) {
                isUpdate = index > -1
                revenues.add(category: category, replace: isUpdate, index: index)
            }
            else{
                revenues.add(category: category, replace: false, index: 0)
            }
            
        }
        print(category.subcategories.count)
        //updateObjectDb(category: category, update: isUpdate)
        
    }

    
}

extension Array {
    mutating func add(category: Element,  replace: Bool, index: Int?){
        if replace {
            self[index!] = category
        }
        else {
            self.append(category)
        }
    }
}

extension UIColor {
    func rgb() -> Int? {
        
//        let redIn: CGFloat = 1
//        let greenIn: CGFloat = 0.5
//        let blueIn: CGFloat = 0.75
//        
//        let redIntIn = Int(redIn * 255)
//        let greenIntIn = Int(greenIn * 255)
//        let blueIntIn = Int(blueIn * 255)
//        
//        let color = blueIntIn << 16 + greenIntIn << 8 + redIntIn
//        return color
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    func rgbToUIColor (_ color: Int) -> UIColor {
        let redIntOut = color & 0xFF
        let greenIntOut = (color & 0xFF00) >> 8
        let blueIntOut = (color & 0xFF0000) >> 16
        
        let redOut = CGFloat(redIntOut) / 255
        let greenOut = CGFloat(greenIntOut) / 255
        let blueOut = CGFloat(blueIntOut) / 255
        return UIColor(red: redOut, green: greenOut, blue: blueOut, alpha: 1)
    }
    
}
