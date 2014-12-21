//
//  ToDoEditorTagTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/03.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorTagTableViewCell: ToDoEditorBaseTableViewCell, UITextFieldDelegate {

    @IBOutlet weak var tagTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.tagTextField.returnKeyType = UIReturnKeyType.Done
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindingString() -> String {
        return "tag"
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.tagTextField.text
    }
    
    override func setValueOfCell(value: AnyObject) {
        if let entityData = value as? String {
            self.tagTextField.text = entityData
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.tagTextField.endEditing(true)
        return true
    }
}
