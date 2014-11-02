//
//  ToDoEditorDueDateTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorDueDateTableViewCell: ToDoEditorDateBaseTableViewCell {

    @IBOutlet weak var dueDateLabel: UILabel!
    
//    var detailView : CommonDatePickerViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.detailView = self.createDetailView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func setValueForDate(datePicker: UIDatePicker) {
        self.dueDateLabel.text = self.stringFromDate(datePicker.date)
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.dueDateLabel.text
    }
    
//    override func detailViewController() -> UIViewController? {
//        
//        return self.detailView
//    }
//    
//    func didFinishDetailView(datePicker : UIDatePicker){
//        // データとしての日付と表示としての日付の扱いを分けるとすれば
//        // データ：数値もしくはロケールによらない固定フォーマット
//        // 表示：ロケールに応じたフォーマット
//       self.dueDateLabel.text = self.stringFromDate(datePicker.date)
//    }
//    
//    func stringFromDate(date : NSDate) -> String {
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd"
//        return dateFormatter.stringFromDate(date)
//    }
//    
//    private func loadDetailView() -> CommonDatePickerViewController? {
//        
//        var vc = NSBundle.mainBundle().loadNibNamed("CommonDatePickerViewController", owner: CommonDatePickerViewController(), options: nil)[0] as? CommonDatePickerViewController
//        
//        return vc
//    }
//    
//    private func createDetailView() -> CommonDatePickerViewController? {
//        
//        var vc = self.loadDetailView()
//        vc?.completeDelegate = self.didFinishDetailView
//
//        return vc
//    }
}
