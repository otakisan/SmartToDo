//
//  ToDoEditorProgressV2TableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/12/30.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorProgressV2TableViewCell: ToDoEditorPickerBaseTableViewCell {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressImageView: UIImageView!
    
    lazy var progressList : [String] = self.createProgressList()
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
        return "progress"
    }
    
    override func valueOfCell() -> AnyObject? {
        // 現在はエンティティへの設定用に用いられているが、
        // 将来的にセル全体としての値を返却する必要があれば、
        // オブジェクトかタプルで返却する
        return (currentCode as NSString).floatValue
    }
    
    override func createPickerDataSource() -> [[String]] {
        return [self.progressList]
    }
    
    override func didFinishPickerView(selectedValue: String) {
        // 選択された進捗率(%表記)を受けての処理
        self.currentCode = self.toProgressStringValue(selectedValue)
        self.progressLabel.text = String(format: "%@%%", selectedValue)
        self.progressImageView.hidden = !self.isCompleted(selectedValue)
    }
    
    override func setStringValueOfCell(valueString: String) {
        // 進捗率をエディターから受けての処理
        self.currentCode = toProgressStringValue(toProgressPercentValueString(valueString))
        let percentString = toProgressPercentValueString(valueString)
        self.progressLabel.text = String(format: "%@%%", percentString)
        self.progressImageView.hidden = !self.isCompleted(percentString)
    }
    
    override func detailViewInitValue() -> AnyObject? {
        return self.toProgressPercentValueString(self.currentCode)
    }
    
    override func syncSelectionAmongComponents() -> Bool {
        // 現在は単一区分のみなので、連動選択は使用しない
        return false
    }
    
    func createProgressList() -> [String] {
        // 5%刻み
        var progressList : [String] = []
        let interval = 5
        for index in 0...(100/interval) {
            progressList.append(String(index * interval))
        }
        
        return progressList
    }
    
    func toProgressPercentValueString(progressValueString : String) -> String {
        let value = (progressValueString as NSString).floatValue
        return String(format: "%.0f", value * 100)
    }
    
    func toProgressStringValue(percentValueString : String) -> String {
        let value = self.toProgressRawValue(percentValueString)
        return (String(format: "%.2f", value) as NSString)
    }
    
    func isCompleted(percentValueString : String) -> Bool {
        return toProgressRoundValue(percentValueString) == 1.0
    }
    
    func toProgressRawValue(percentValueString : String) -> Float {
        let value = (percentValueString as NSString).floatValue / 100
        return value
    }

    func toProgressRoundValue(percentValueString : String) -> Float {
        let value = (toProgressStringValue(percentValueString) as NSString).floatValue
        return value
    }
}
