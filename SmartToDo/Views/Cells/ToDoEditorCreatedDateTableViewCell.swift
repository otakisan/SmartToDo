//
//  ToDoEditorCreatedDateTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/03.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorCreatedDateTableViewCell: ToDoEditorDateBaseTableViewCell {

    @IBOutlet weak var createdDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setValueForDate(datePicker: UIDatePicker) {
        self.createdDateLabel.text = self.stringFromDate(datePicker.date)
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.createdDateLabel.text
    }
    
    override func setDateStringOfCell(value: String) {
        self.createdDateLabel.text = value
    }
    
    override func bindingString() -> String {
        return "createdDate"
    }
    
    // 読み取り専用なので詳細画面への遷移はさせない
    //    override func detailViewInitValue() -> AnyObject? {
    //        return self.dateFromString(self.createdDateLabel.text ?? "") ?? NSDate()
    //    }
    override func createDetailView() -> UIViewController? {
        return nil
    }
}
