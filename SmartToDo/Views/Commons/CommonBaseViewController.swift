//
//  CommonBaseViewController.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class CommonBaseViewController: UIViewController {

    var completeDelegate : ((UIView) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.edgesForExtendedLayout = UIRectEdge.None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViewValue(value : AnyObject){
        
    }
    
    func view() -> UIView! {
        return nil
    }
    
    func callCompleteDelegate(){
        if completeDelegate != nil && self.view() != nil {
            self.completeDelegate!(self.view()!)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol CommonView {
    func setViewValue(value : AnyObject)
}
