//
//  CommonDatePickerViewController.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class CommonDatePickerViewController: UIViewController {
    
    var completeDelegate : ((UIDatePicker) -> Void)?
    
//    @IBAction func okDidTouchUpInside(sender: UIButton) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        if completeDelegate != nil {
//            self.completeDelegate!(self.datePicker)
//        }
//    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.None
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.callCompleteDelegate()
    }
    
    func setViewValue(value: AnyObject) {
        if let valueDate = value as? NSDate {
            self.datePicker.date = valueDate
        }
    }

//    override func view() -> UIView! {
//        return self.datePicker
//    }
    
    func callCompleteDelegate(){
        if completeDelegate != nil {
            self.completeDelegate!(self.datePicker)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class CommonDatePickerViewDelegate : NSObject {
    
}