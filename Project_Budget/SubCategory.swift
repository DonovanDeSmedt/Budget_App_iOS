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
    

}
