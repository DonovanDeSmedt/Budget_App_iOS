import Foundation
import UIKit

import Realm
import RealmSwift


class Transaction: Object{
    dynamic var amount: Double = 0.0
    dynamic var date: Date = Date()
    
}
