import Foundation
import UIKit
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter
{
    var names = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String
    {
        return names[Int(value)]
    }
    
    public func setValues(values: [String])
    {
        self.names = values
    }
}
