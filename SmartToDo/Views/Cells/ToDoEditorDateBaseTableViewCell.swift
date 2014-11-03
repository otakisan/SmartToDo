//
//  ToDoEditorDateBaseTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorDateBaseTableViewCell: ToDoEditorBaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func completeDelegate() -> ((UIView) -> Void)? {
        return self.didFinishDetailView
    }
    
    func didFinishDetailView(detailView : UIView){
        if let view = detailView as? UIDatePicker {
            self.setValueForDate(view)
        }
    }
    
    func setValueForDate(datePicker : UIDatePicker){
        // Subclass Must Implement
    }
    
    override func setValueOfCell(value: AnyObject) {
        if let entityData = value as? NSDate {
            self.setDateStringOfCell(self.stringFromDate(entityData))
        }
    }
    
    func setDateStringOfCell(value : String){
        
    }

    func dateFormatter() -> NSDateFormatter {
        // データとしての日付と表示としての日付の扱いを分けるとすれば
        // データ：数値もしくはロケールによらない固定フォーマット
        // 表示：ロケールに応じたフォーマット
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }
    
    func stringFromDate(date : NSDate) -> String {
        return self.dateFormatter().stringFromDate(date)
    }
    
    func dateFromString(dateString : String) -> NSDate? {
        return self.dateFormatter().dateFromString(dateString)
    }
    
    func loadDetailView() -> CommonDatePickerViewController? {
        
        var vc = NSBundle.mainBundle().loadNibNamed("CommonDatePickerViewController", owner: CommonDatePickerViewController(), options: nil)[0] as? CommonDatePickerViewController
        
        return vc
    }
    
    override func createDetailView() -> UIViewController? {
        
        var vc = self.loadDetailView()
        vc?.setViewValue(self.detailViewInitValue()!)
        vc?.completeDelegate = self.didFinishDetailView
        
        return vc
    }
    
    func detailViewInitValue() -> AnyObject? {
        return NSDate()
    }
}
