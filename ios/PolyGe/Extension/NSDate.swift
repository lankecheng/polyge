//
//  Date.swift
//  PolyGe
//
//  Created by king on 15/7/11.
//  Copyright © 2015年 king. All rights reserved.
//

import Foundation
//import Timepiece
extension NSDate {
    
    // MARK: To String
    
    func toString() -> String {
        return self.toString(dateStyle: .ShortStyle, timeStyle: .ShortStyle, doesRelativeDateFormatting: false)
    }
    
    func toString(dateStyle dateStyle: NSDateFormatterStyle, timeStyle: NSDateFormatterStyle, doesRelativeDateFormatting: Bool = false) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        return formatter.stringFromDate(self)
    }
    
    func relativeTimeToString(containTime: Bool = false) -> String
    {
        let timeInterval = NSDate() - self
        if timeInterval < 1.day {
            return self.stringFromFormat("HH:mm")
        }else if timeInterval < 2.day {
            if containTime {
                 KSLocalizedString("昨天") + self.stringFromFormat(" HH:mm")
            }else{
                return KSLocalizedString("昨天")
            }
        }else if timeInterval < 7.week {
            if containTime {
                return self.stringFromFormat("EEE HH:mm")
            }else{
                return self.stringFromFormat("EEE")
            }
        }
        if containTime {
            return self.stringFromFormat("yy/MM/dd HH:mm")
        }else{
            return self.stringFromFormat("yy/MM/dd")
        }
    }
}

