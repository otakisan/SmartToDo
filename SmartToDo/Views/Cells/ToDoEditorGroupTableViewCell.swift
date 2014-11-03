//
//  ToDoEditorGroupTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorGroupTableViewCell: ToDoEditorPickerBaseTableViewCell {

    @IBOutlet weak var groupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.groupLabel.text
    }
    
    override func didFinishPickerView(selectedValue: String) {
        self.groupLabel.text = selectedValue
    }

    override func setStringValueOfCell(valueString: String) {
        self.groupLabel.text = valueString
    }
    
    override func bindingString() -> String {
        return "group"
    }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.groupLabel.text ?? ""
    }
    
    override func createPickerDataSource() -> [[String]] {
        // TODO: マスタから取得するもよし、固定項目にするもよし
        return [["group1", "group2", "init group"]]
    }
    
}
