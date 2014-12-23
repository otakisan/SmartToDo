//
//  ToDoEditorGroupTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorGroupTableViewCell: ToDoEditorPickerBaseTableViewCell {
    
    var taskStoreService = TaskStoreService()
    
    @IBOutlet weak var groupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        // 新規項目ならリストに追加
        var filterResult = self.dataLists.filter({
            (elementList : [String]) -> Bool in
            
            var filterResultInner = elementList.filter({(element : String) -> Bool in return element == selectedValue})
            return filterResultInner.count > 0
        })
        
        if filterResult.count == 0 {
            self.dataLists[0].append(selectedValue)
        }
        
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
        self.initializeDataSource()
        return self.dataLists
    }
    
    override func canFreeText() -> Bool {
        // 任意のグループを設定可能とする
        return true
    }
    
    func initializeDataSource(){
        // TODO: 現在の仕様では、登録済のデータに対し、GroupByでまとめ、項目を取得することとする
        
        self.dataLists = [[]]
        var resultList = self.taskStoreService.getGroups()
        for result in resultList {
            self.dataLists[0].append(result.group)
        }
    }
}
