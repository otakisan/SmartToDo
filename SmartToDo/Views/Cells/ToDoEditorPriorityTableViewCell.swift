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

    @IBAction func didValueChange(sender: UIStepper) {
        self.priorityLabel.text = Int32(sender.value).description
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
}
