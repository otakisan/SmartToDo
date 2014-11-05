//
//  ToDoEditorCompletionDateTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorCompletionDateTableViewCell: ToDoEditorDateBaseTableViewCell {

    @IBOutlet weak var completionDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setValueForDate(datePicker: UIDatePicker) {
        self.completionDateLabel.text = self.stringFromDate(datePicker.date)
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.dateFromString(self.completionDateLabel.text!)
    }
    
    override func setDateStringOfCell(value: String) {
        self.completionDateLabel.text = value
    }

    override func bindingString() -> String {
        return "completionDate"
    }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.dateFromString(self.completionDateLabel.text ?? "") ?? NSDate()
    }
}
