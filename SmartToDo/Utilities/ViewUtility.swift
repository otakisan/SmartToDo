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
        
        let alertController : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: UIAlertActionStyle.Default, handler: nil))
        
        view.presentViewController(alertController, animated: true, completion: nil)
        
    }
}
