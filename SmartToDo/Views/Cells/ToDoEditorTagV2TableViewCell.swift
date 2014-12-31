//
//  ToDoEditorTagV2TableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/12/31.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorTagV2TableViewCell: ToDoEditorTextBaseTableViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindingString() -> String {
        return "tag"
    }
    
    override func didFinishTextView(textView: UITextView) {
        self.tagLabel.text = textView.text
    }
    
    override func setTextValueOfCell(textValue: String) {
        self.tagLabel.text = textValue
    }
    
    override func textValueOfCell() -> String {
        return self.tagLabel.text ?? ""
    }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.tagLabel.text ?? ""
    }
    
}
