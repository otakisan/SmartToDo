//
//  ToDoEditorProgressTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorProgressTableViewCell: ToDoEditorBaseTableViewCell {

    @IBOutlet weak var progressSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.progressSlider.value
    }
    
    override func setValueOfCell(value: AnyObject) {
        if let entityData = value as? Float {
            self.progressSlider.value = entityData
        }
    }
    
    override func bindingString() -> String {
        return "progress"
    }

}
