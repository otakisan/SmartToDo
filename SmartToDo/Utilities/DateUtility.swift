//
//  DateUtility.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/08.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class DateUtility: NSObject {
    
    class func isEqualDateComponent(date1 : NSDate, date2 : NSDate) -> Bool{
        
        // 日付部分が同一かどうか
        let unitFlags: NSCalendarUnit = [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.TimeZone]
        
        let compo1 = NSCalendar.currentCalendar().components(unitFlags, fromDate: date1)
        let compo2 = NSCalendar.currentCalendar().components(unitFlags, fromDate: date2)
        
        compo1.timeZone = NSTimeZone.systemTimeZone()
        compo2.timeZone = NSTimeZone.systemTimeZone()
        
        return compo1.year == compo2.year && compo1.month == compo2.month && compo1.day == compo2.day
    }

    private class func edgeOfDay(date : NSDate, edgeString : String) -> NSDate {
        let formatterSrc = NSDateFormatter()
        formatterSrc.dateFormat = "yyyyMMdd"
        let dateStringSrc = formatterSrc.stringFromDate(date)
        
        let formatterDst = NSDateFormatter()
        formatterDst.dateFormat = "yyyyMMddHHmmssSSS"
        
        return formatterDst.dateFromString("\(dateStringSrc)\(edgeString)")!
    }
    
    class func firstEdgeOfDay(date : NSDate) -> NSDate {
        return edgeOfDay(date, edgeString: "000000000")
    }

    class func lastEdgeOfDay(date : NSDate) -> NSDate {
        return edgeOfDay(date, edgeString: "235959999")
    }
}
