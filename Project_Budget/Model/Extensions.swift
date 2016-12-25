//
//  Extensions.swift
//  Project_Budget
//
//  Created by Donovan De Smedt on 23/12/16.
//  Copyright © 2016 Donovan De Smedt. All rights reserved.
//

import Foundation
import UIKit


extension Date{
    func getYear() -> Int{
        let dateComponents = NSCalendar.current.dateComponents([.year], from: self)
        return dateComponents.year!
    }
    func getMonthNumber() -> Int{
        let dateComponents = NSCalendar.current.dateComponents([.month], from: self)
        return dateComponents.month!
    }
    func getMonthName() -> String{
        let dateComponents = NSCalendar.current.dateComponents([.month], from: self)
        let month = dateComponents.month!
        return DateFormatter().monthSymbols![month - 1] as String
    }
    func getNextMonth() -> (String, Int, Int) {
        let date = Calendar.current.date(byAdding: .month, value: 1, to: self)!
        return (date.getMonthName(), date.getMonthNumber(), date.getYear())
    }
    func getPreviousMonth() -> (String, Int, Int){
        let date = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return (date.getMonthName(), date.getMonthNumber(), date.getYear())
    }
    func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
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
