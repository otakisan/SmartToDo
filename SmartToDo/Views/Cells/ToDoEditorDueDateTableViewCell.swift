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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
    
    override func setDateStringOfCell(value: String) {
        self.dueDateLabel.text = value
    }
    
    override func bindingString() -> String {
        return "dueDate"
    }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.dateFromString(self.dueDateLabel.text ?? "") ?? NSDate()
    }
}
