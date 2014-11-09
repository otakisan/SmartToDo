//
//  ToDoEditorProgressTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorProgressTableViewCell: ToDoEditorBaseTableViewCell {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBAction func valueChangedProgressSlider(sender: UISlider) {
        self.setProgressValue(sender.value)
    }
    
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
            self.setProgressValue(entityData)
        }
    }
    
    override func bindingString() -> String {
        return "progress"
    }
    
    func setProgressValue(value : Float) {
        
        self.progressSlider.value = value
        
        var progress = Int32(value * 100)
        self.progressLabel.text = "\(progress)"
        
        self.refreshAccessoryType()
    }

    override func refreshAccessoryType() {
        self.accessoryType = self.progressSlider.value == 1.0 ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
    }
}
