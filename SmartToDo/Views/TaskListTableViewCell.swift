//
//  TaskListTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/11.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet var taskTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.taskTitleLabel.text = "task title"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }

}
