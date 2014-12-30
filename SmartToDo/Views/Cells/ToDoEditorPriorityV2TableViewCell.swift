//
//  ToDoEditorPriorityV2TableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/12/30.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorPriorityV2TableViewCell: ToDoEditorPickerBaseTableViewCell {
    
    lazy var priorityTable : [String:String] = self.createPriorityTable()
    var currentCode = ""

    @IBOutlet weak var priorityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindingString() -> String {
        return "priority"
    }
    
    override func valueOfCell() -> AnyObject? {
        // 現在はエンティティへの設定用に用いられているが、
        // 将来的にセル全体としての値を返却する必要があれば、
        // オブジェクトかタプルで返却する
        return currentCode.toInt()
    }
    
    override func createPickerDataSource() -> [[String]] {
        let keyList = self.priorityTable.keys.array.sorted({(lhs, rhs) -> Bool in return lhs.toInt() < rhs.toInt()})
        
        var valueList : [String] = []
        for key in keyList {
            if let value = self.priorityTable[key]{
                valueList.append(value)
            }
        }
        
        return [keyList, valueList]
    }
    
    override func didFinishPickerView(selectedValue: String) {
        // 選択されたコード値を受けての処理
        self.currentCode = selectedValue
        if let value = priorityTable[selectedValue] {
            self.priorityLabel.text = value
        }
    }
    
    override func setStringValueOfCell(valueString: String) {
        // 優先度のコード値をエディターから受けての処理
        if let codeInt = valueString.toFloatToInt() {
            self.currentCode = String(codeInt)
            if let value = self.priorityTable[self.currentCode] {
                self.priorityLabel.text = value
            }
        }
  }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.priorityTable[self.currentCode]
    }
    
    override func syncSelectionAmongComponents() -> Bool {
        return true
    }
    
    func createPriorityTable() -> [String:String] {
        // コード：優先度(0〜10) 値：説明
        var valueKeyList : [String] = [
            "Idle", "Low", "Below", "Normal", "Above", "High", "TimeCritical"
        ]
        
        var priorityTable : [String:String] = [:]
        for index in 0..<valueKeyList.count {
            priorityTable[String(index)] = valueKeyList[index].localized()
        }
        
        return priorityTable
    }
}
