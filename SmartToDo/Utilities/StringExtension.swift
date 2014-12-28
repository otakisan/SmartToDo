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
}
