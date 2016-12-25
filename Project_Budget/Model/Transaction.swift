import Foundation
import UIKit

import Realm
import RealmSwift


class Transaction: Object{
    dynamic var amount: Double = 0.0
    dynamic var date: Date = Date()
    
    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? Transaction {
            return self.amount == other.amount && self.date == other.date
        } else {
            return false
        }
    }
    
}
