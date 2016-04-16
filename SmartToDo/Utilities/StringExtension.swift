//
//  StringExtension.swift
//  SmartToDo
//
//  Created by takashi on 2014/12/28.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(args : [CVarArgType]) -> String {
        return String(format: self.localized(), arguments: args)
    }
    
    func toFloat() -> Float {
        return (self as NSString).floatValue
    }
    
    func toFloatToInt() -> Int? {
        return Int(String(format: "%.0f", self.toFloat()))
    }
}
