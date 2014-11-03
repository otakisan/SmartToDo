//
//  ToDoEditorDetailTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/03.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorDetailTableViewCell: ToDoEditorTextBaseTableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindingString() -> String {
        return "detail"
    }
    
    override func didFinishTextView(textView: UITextView) {
        self.detailLabel.text = textView.text
    }
    
    override func setTextValueOfCell(textValue: String) {
        self.detailLabel.text = textValue
    }
    
    override func textValueOfCell() -> String {
        return self.detailLabel.text ?? ""
    }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.detailLabel.text ?? ""
    }
}
