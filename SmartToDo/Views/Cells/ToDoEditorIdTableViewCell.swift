//
//  ToDoEditorIdTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorIdTableViewCell: ToDoEditorBaseTableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.idLabel.text
    }
    
    override func setValueOfCell(value: AnyObject) {
        if let entityData = value as? String {
            self.idLabel.text = entityData
        }
    }
    
    override func bindingString() -> String {
        return "id"
    }
}
