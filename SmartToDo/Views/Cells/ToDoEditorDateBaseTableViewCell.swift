//
//  ToDoEditorDateBaseTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorDateBaseTableViewCell: ToDoEditorBaseTableViewCell {

    var detailView : CommonDatePickerViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.detailView = self.createDetailView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func detailViewController() -> UIViewController? {
        
        return self.detailView
    }
    
    func didFinishDetailView(datePicker : UIDatePicker){
        self.setValueForDate(datePicker)
//        self.dueDateLabel.text = self.stringFromDate(datePicker.date)
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
    
    private func loadDetailView() -> CommonDatePickerViewController? {
        
        var vc = NSBundle.mainBundle().loadNibNamed("CommonDatePickerViewController", owner: CommonDatePickerViewController(), options: nil)[0] as? CommonDatePickerViewController
        
        return vc
    }
    
    private func createDetailView() -> CommonDatePickerViewController? {
        
        var vc = self.loadDetailView()
        vc?.initValue = self.detailViewInitValue()
        vc?.completeDelegate = self.didFinishDetailView
        
        return vc
    }
    
    func detailViewInitValue() -> NSDate {
        return NSDate()
    }
}
