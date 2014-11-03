//
//  ToDoEditorTitleTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorTitleTableViewCell: ToDoEditorTextBaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindingString() -> String {
        return "title"
    }
    
    override func didFinishTextView(textView: UITextView) {
        self.titleLabel.text = textView.text
    }
    
    override func setTextValueOfCell(textValue: String) {
        self.titleLabel.text = textValue
    }
    
    override func textValueOfCell() -> String {
        return self.titleLabel.text ?? ""
    }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.titleLabel.text ?? ""
    }
}
