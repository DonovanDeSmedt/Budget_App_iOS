//
//  SubCategory.swift
//  Project_Budget
//
//  Created by Donovan De Smedt on 14/12/16.
//  Copyright © 2016 Donovan De Smedt. All rights reserved.
//

import Foundation
import RealmSwift

class Subcategory: Object{
    dynamic var name: String = ""
    var transactions = List<Transaction>()
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? Subcategory {
            return self.name == other.name
        } else {
            return false
        }
    }

}
