//
//  ToDoEditorLastModifiedDateTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/03.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorLastModifiedDateTableViewCell: ToDoEditorDateBaseTableViewCell {

    @IBOutlet weak var lastModifiedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setValueForDate(datePicker: UIDatePicker) {
        self.lastModifiedDateLabel.text = self.stringFromDate(datePicker.date)
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.dateFromString(self.lastModifiedDateLabel.text!)
    }
    
    override func setDateStringOfCell(value: String) {
        self.lastModifiedDateLabel.text = value
    }
    
    override func bindingString() -> String {
        return "lastModifiedDate"
    }
    
    // 読み取り専用なので詳細画面への遷移はさせない
//    override func detailViewInitValue() -> AnyObject? {
//        return self.dateFromString(self.lastModifiedDateLabel.text ?? "") ?? NSDate()
//    }
    override func createDetailView() -> UIViewController? {
        return nil
    }
}
