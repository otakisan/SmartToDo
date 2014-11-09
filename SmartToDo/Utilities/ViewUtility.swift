//
//  ViewUtility.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/09.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ViewUtility: NSObject {
    
    class func showMessageDialog(view : UIViewController, title : String, message : String){
        
        var message:UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
        
        view.presentViewController(message, animated: true, completion: nil)
        
    }
}
