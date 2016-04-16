//
//  ToDoEditorPriorityTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/03.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorPriorityTableViewCell: ToDoEditorBaseTableViewCell {

    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var priorityStepper: UIStepper!
    
    @IBAction func didValueChange(sender: UIStepper) {
        self.priorityLabel.text = self.toString(sender.value)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindingString() -> String {
        return "priority"
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.priorityStepper.value
    }
    
    override func setValueOfCell(value: AnyObject) {
        // 数値ならDoubleに変換してOKにしたい
        if let entityData = value as? Double {
            self.priorityStepper.value = entityData
            self.priorityLabel.text = self.toString(entityData)
        }
    }
    
    func toString(doubleValue : Double) -> String {
        let numericValue = Int32(doubleValue)
        return "\(numericValue)"
    }
}
