//
//  CommonTextViewController.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class CommonTextViewController: UIViewController {

    var completeDelegate : ((UIView) -> Void)?

    @IBOutlet weak var textView: UITextView!
    
//    @IBAction func okDidTouchUpInside(sender: UIButton) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        if completeDelegate != nil {
//            self.completeDelegate!(self.textView)
//        }
//    }

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
        if let valueString = value as? String {
            self.textView.text = valueString
        }
    }
    
    func setCompleteDeleage(delegate : ((UIView) -> Void)?){
        self.completeDelegate = delegate
    }
    
//    override func view() -> UIView! {
//        return self.textView
//    }
    
    func callCompleteDelegate(){
        if completeDelegate != nil {
            self.completeDelegate!(self.textView)
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
