//
//  Category.swift
//  Project_Budget
//
//  Created by Donovan De Smedt on 14/12/16.
//  Copyright © 2016 Donovan De Smedt. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


class Category: Object{
    dynamic var name: String = ""
    var subcategories = List<Subcategory>()
    dynamic var color: Int = 0
    
    dynamic var categorytype = TransactionType.expense.rawValue

    var type: TransactionType {
        get {
            return TransactionType(rawValue: categorytype)!
        }
        set {
            categorytype = newValue.rawValue
        }
    }
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? Category {
            return self.compoundKeyValue() == other.compoundKeyValue()
        } else {
            return false
        }
    }
    
    
    //dynamic var compoundKey: String{return "\(name)\(type.hashValue)"}
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
    func compoundKeyValue() -> String {
        return "\(name)\(type.hashValue)"
    }
}

enum TransactionType: Int {
    case expense = 0
    case revenue = 1
}
