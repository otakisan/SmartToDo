//
//  TaskListTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/11.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskProgressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.taskTitleLabel.text = "task title"
        self.taskProgressView.progress = 0.6
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state

    }

}
