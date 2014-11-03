//
//  CommonPickerViewController.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class CommonPickerViewController: UIViewController {

    var dataLists = [[String]]()
    var completeDelegate : ((UIView) -> Void)?

    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.callCompleteDelegate()
    }

    func setViewValue(value: AnyObject) {
        if let valueStrings = value as? String {
            for listComponentIndex in 0 ..< self.dataLists.count {
                if let rowIndex = find(self.dataLists[listComponentIndex], valueStrings) {
                    self.pickerView.selectRow(rowIndex, inComponent: listComponentIndex, animated: false)
                }
            }
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
        return self.pickerView
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
    
}