//
//  CommonPickerViewController.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

/**
 共通部品（PickerView）
 任意の項目の選択及び任意の値の入力を可能とする
 モードの指定により、選択項目のみか任意の値の入力も可能にするか設定可能
*/
class CommonPickerViewController: UIViewController {

    /**
     PickerViewに表示する項目
    */
    var dataLists = [[String]]()
    
    /**
     完了イベントハンドラ
    */
    var completeDelegate : ((UIView) -> Void)?

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldBottomLayoutGuideConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.textField.returnKeyType = UIReturnKeyType.Done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObserver()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
  
        removeKeyboardObserver()
        
        self.callCompleteDelegate()
    }

    func setViewValue(value: AnyObject?) {
        if let valueString = value as? String {
            for listComponentIndex in 0 ..< self.dataLists.count {
                if let rowIndex = find(self.dataLists[listComponentIndex], valueString) {
                    self.pickerView.selectRow(rowIndex, inComponent: listComponentIndex, animated: false)
                }
            }
            
            self.textField.text = valueString
        }
    }
    
    func setDataSource(value: AnyObject) {
        if let valueStrings = value as? [[String]] {
            self.dataLists = valueStrings
            self.pickerView.reloadAllComponents()
        }
    }
    
    func setCompleteDeleage(delegate : ((UIView) -> Void)?){
        self.completeDelegate = delegate
    }

    func callCompleteDelegate(){
        
        if let callback = self.completeDelegate {
            if let view = self.resultView() {
                callback(view)
            }
        }
    }
    
    func resultView() -> UIView? {
        return self.canFreeText ? self.textField : self.pickerView
    }
    
    /**
     任意の値を入力可能にするか
    */
    var canFreeText : Bool {
        // ロード後のコールであることが前提条件
        set{
            self.textField.hidden = !newValue
        }
        get{
            return !self.textField.hidden
        }
    }
    
    func addKeyboardObserver(){
        // Listen for changes to keyboard visibility so that we can adjust the text view accordingly.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "handleKeyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "handleKeyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver(){
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: true)
    }
    
    func handleKeyboardWillHideNotification(notification: NSNotification) {
        keyboardWillChangeFrameWithNotification(notification, showsKeyboard: false)
    }
    
    // MARK: Convenience
    
    func keyboardWillChangeFrameWithNotification(notification: NSNotification, showsKeyboard: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        
        // Convert the keyboard frame from screen to view coordinates.
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        // The text view should be adjusted, update the constant for this constraint.
        textFieldBottomLayoutGuideConstraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
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

extension CommonPickerViewController : UIPickerViewDataSource {
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return self.dataLists.count
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataLists[component].count
    }
    
}

extension CommonPickerViewController : UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        return self.dataLists[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.textField.text = self.dataLists[component][row]
    }
}

extension CommonPickerViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doneBarButtonItemClicked()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        let backBarButtonItem = UIBarButtonItem(title: "Done&Back", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("backButtonToucheUpInside"))
        
        navigationItem.setLeftBarButtonItem(backBarButtonItem, animated: true)
    }
    
    func doneBarButtonItemClicked() {
        // Dismiss the keyboard by removing it as the first responder.
        textField.endEditing(true)
        
        navigationItem.setLeftBarButtonItem(nil, animated: true)
    }
    
    func backButtonToucheUpInside(){
        doneBarButtonItemClicked()
        self.navigationController?.popViewControllerAnimated(true)
    }
}