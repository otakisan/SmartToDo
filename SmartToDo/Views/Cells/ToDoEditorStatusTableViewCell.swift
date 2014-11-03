//
//  ToDoEditorStatusTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/03.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorStatusTableViewCell: ToDoEditorPickerBaseTableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindingString() -> String {
        return "status"
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.statusLabel.text
    }

    override func createPickerDataSource() -> [[String]] {
        // TODO: マスタから取得するもよし、固定項目にするもよし
        return [["Not Started", "In Progress", "Done"]]
    }
    
    override func didFinishPickerView(selectedValue: String) {
        self.statusLabel.text = selectedValue
    }
    
    override func setStringValueOfCell(valueString: String) {
        self.statusLabel.text = valueString
    }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.statusLabel.text
    }
}
