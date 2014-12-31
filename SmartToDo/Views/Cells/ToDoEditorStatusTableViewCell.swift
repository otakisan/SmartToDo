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
    
    lazy var statusTable : [String:String] = self.createStatusTable()
    var currentCode = ""

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
        return self.currentCode
    }
    
    override func didFinishPickerView(selectedValue: String) {
        // コード値を受けての処理（ピッカーから）
        self.currentCode = selectedValue
        if let displayText = self.statusTable[self.currentCode] {
            self.statusLabel.text = displayText
        }
    }
    
    override func setStringValueOfCell(valueString: String) {
        // コード値を受けての処理（エディターから）
        self.currentCode = valueString
        if let displayText = self.statusTable[self.currentCode] {
            self.statusLabel.text = displayText
        }
    }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.statusLabel.text
    }
    
    override func createPickerDataSource() -> [[String]] {
        let keyList = self.statusTable.keys.array.sorted({(lhs, rhs) -> Bool in return lhs.toInt() < rhs.toInt()})
        
        var valueList : [String] = []
        for key in keyList {
            if let value = self.statusTable[key]{
                valueList.append(value)
            }
        }
        
        return [keyList, valueList]
    }
    
    override func syncSelectionAmongComponents() -> Bool {
        return true
    }
    
    func createStatusTable() -> [String:String] {
        // ステータスコード
        var valueKeyList : [String] = [
            "Memo", "Planning", "NotStarted", "InProgress", "Pending", "Cancel", "Done"
        ]
        
        var statusTable : [String:String] = [:]
        for index in 0..<valueKeyList.count {
            statusTable[String(index)] = valueKeyList[index].localized()
        }
        
        return statusTable
    }
}
