//
//  UnfinishedTaskListTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/09.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class UnfinishedTaskListTableViewCell: UITableViewCell {

    var toDoTaskEntity : ToDoTaskEntity?
    
    @IBOutlet weak var taskSummaryLabel: UILabel!
    @IBOutlet weak var copyTargetSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshDisplay(entity : ToDoTaskEntity) {
        self.toDoTaskEntity = entity
        self.taskSummaryLabel.text = entity.title
    }
    
}
