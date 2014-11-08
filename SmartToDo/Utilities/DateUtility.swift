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
        var unitFlags = NSCalendarUnit.CalendarUnitYear
            | NSCalendarUnit.CalendarUnitMonth
            | NSCalendarUnit.CalendarUnitDay
            | NSCalendarUnit.CalendarUnitTimeZone
        
        var compo1 = NSCalendar.currentCalendar().components(unitFlags, fromDate: date1)
        var compo2 = NSCalendar.currentCalendar().components(unitFlags, fromDate: date2)
        
        compo1.timeZone = NSTimeZone.systemTimeZone()
        compo2.timeZone = NSTimeZone.systemTimeZone()
        
        return compo1.year == compo2.year && compo1.month == compo2.month && compo1.day == compo2.day
    }
}
