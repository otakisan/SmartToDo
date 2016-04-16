//
//  ToDoEditorPickerBaseTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/03.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorPickerBaseTableViewCell: ToDoEditorBaseTableViewCell {

    lazy var dataLists : [[String]] = self.createPickerDataSource()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setValueOfCell(value: AnyObject) {
        if let entityData = value as? String {
            self.setStringValueOfCell(entityData)
        }
        else if let entityDataNumber = value as? NSNumber {
            self.setStringValueOfCell(String(format: "%f", entityDataNumber.floatValue))
        }
    }
    
    func setStringValueOfCell(valueString : String) {
        
    }
    
    func completeDelegate() -> ((UIView) -> Void)? {
        return self.didFinishDetailView
    }
    
    func didFinishDetailView(detailView : UIView){
        
        if let view = detailView as? UIPickerView {
            // 現在の仕様上は、１区分のみ必要のため、固定で先頭区分から取得
            // 区分ごとの個別の値を返却する必要が出たら、タプルにして返却する
            let selectedIndex = view.selectedRowInComponent(0)
            if selectedIndex >= 0 {
                let valueString = self.dataLists[0][selectedIndex]
                self.didFinishPickerView(valueString)
            }
        }
        else if let textField = detailView as? UITextField {
            self.didFinishPickerView(textField.text ?? "")
        }
    }
    
    func didFinishPickerView(selectedValue : String) {
        
    }
    
    override func createDetailView() -> UIViewController? {
        
        let vc = self.loadDetailView()
        vc?.canFreeText = self.canFreeText()
        vc?.syncSelectionAmongComponents = self.syncSelectionAmongComponents()
        vc?.setCompleteDeleage(self.completeDelegate())
        
        return vc
    }
    
    func loadDetailView() -> CommonPickerViewController? {
        
        let vc = NSBundle.mainBundle().loadNibNamed("CommonPickerViewController", owner: nil, options: nil)[0] as? CommonPickerViewController
        
        return vc
    }
    
    override func detailViewController() -> UIViewController? {
        let vc = super.detailViewController() as? CommonPickerViewController
        vc?.setDataSource(self.dataSource())
        vc?.setViewValue(self.detailViewInitValue())
        
        return vc
    }
    
    func detailViewInitValue() -> AnyObject? {
        return nil
    }
    
    func dataSource() -> [[String]] {
        return dataLists
    }
    
    func createPickerDataSource() -> [[String]] {
        return [[]]
    }
    
    func canFreeText() -> Bool {
        return false
    }
    
    func syncSelectionAmongComponents() -> Bool {
        return false
    }

}
