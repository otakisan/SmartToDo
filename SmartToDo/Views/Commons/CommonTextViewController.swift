//
//  CommonTextViewController.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class CommonTextViewController: UIViewController, UITextViewDelegate {

    var completeDelegate : ((UIView) -> Void)?
    
    // 下記２つのOutletはキーボード表示時のレイアウト調整の対応でweak->strongにしたけど
    // 関係ないのであれば元に戻す
    @IBOutlet var textViewBottomLayoutGuideConstraint: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    
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
    
    func callCompleteDelegate(){
        if completeDelegate != nil {
            self.completeDelegate!(self.textView)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardObserver()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeKeyboardObserver()
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
        // 入力候補の表示がされたときの対応をどうするか
        let tabBarHeight = /*self.tabBarController?.rotatingFooterView()?.frame.size.height ?? */CGFloat(0)
        let originDelta = keyboardViewEndFrame.origin.y - (keyboardViewBeginFrame.origin.y - tabBarHeight)
        
        // The text view should be adjusted, update the constant for this constraint.
        textViewBottomLayoutGuideConstraint.constant -= originDelta
        
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        // Scroll to the selected text once the keyboard frame changes.
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
    func adjustTextViewSelection(textView: UITextView) {
        // Ensure that the text view is visible by making the text view frame smaller as text can be slightly cropped at the bottom.
        // Note that this is a workwaround to a bug in iOS.
        
        textView.layoutIfNeeded()
        
        var caretRect = textView.caretRectForPosition(textView.selectedTextRange!.end)
        caretRect.size.height += textView.textContainerInset.bottom
        textView.scrollRectToVisible(caretRect, animated: false)
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        // Provide a "Done" button for the user to select to signify completion with writing text in the text view.
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneBarButtonItemClicked")
        
        navigationItem.setRightBarButtonItem(doneBarButtonItem, animated: true)
        
        // 標準のbackボタンに外観を揃えたいけど、UIButtonTypeで101を指定してもうまくいかない
//        var backButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
//        backButton.setTitle("Done&Back", forState: UIControlState.Normal)
//        backButton.addTarget(self, action: Selector("backButtonToucheUpInside"), forControlEvents: UIControlEvents.TouchUpInside)
//        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let backBarButtonItem = UIBarButtonItem(title: "Done&Back", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("backButtonToucheUpInside"))
        
        navigationItem.setLeftBarButtonItem(backBarButtonItem, animated: true)
        
        adjustTextViewSelection(textView)
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        adjustTextViewSelection(textView)
    }
    
    // MARK: Actions
    
    func doneBarButtonItemClicked() {
        // Dismiss the keyboard by removing it as the first responder.
        textView.resignFirstResponder()
        
        navigationItem.setRightBarButtonItem(nil, animated: true)
        navigationItem.setLeftBarButtonItem(nil, animated: true)
    }
    
    func backButtonToucheUpInside(){
        doneBarButtonItemClicked()
        self.navigationController?.popViewControllerAnimated(true)
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
