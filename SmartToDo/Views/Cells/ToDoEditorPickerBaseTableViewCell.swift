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
    
//    override func valueOfCell() -> AnyObject? {
//        return self.groupLabel.text
//    }
    
    override func setValueOfCell(value: AnyObject) {
        if let entityData = value as? String {
            self.setStringValueOfCell(entityData)
        }
    }
    
    func setStringValueOfCell(valueString : String) {
        
    }
    
//    override func bindingString() -> String {
//        return "group"
//    }
    
    func completeDelegate() -> ((UIView) -> Void)? {
        return self.didFinishDetailView
    }
    
    func didFinishDetailView(detailView : UIView){
        
        if let view = detailView as? UIPickerView {
            var selectedIndex = view.selectedRowInComponent(0)
            if selectedIndex >= 0 {
                var valueString = self.dataLists[0][selectedIndex]
                self.didFinishPickerView(valueString)
            }
        }
    }
    
    func didFinishPickerView(selectedValue : String) {
        
    }
    
    override func createDetailView() -> UIViewController? {
        
        var vc = self.loadDetailView()
        vc?.setDataSource(self.dataSource())
        vc?.setViewValue(self.detailViewInitValue())
        vc?.setCompleteDeleage(self.completeDelegate())
        
        return vc
    }
    
    func loadDetailView() -> CommonPickerViewController? {
        
        var vc = NSBundle.mainBundle().loadNibNamed("CommonPickerViewController", owner: nil, options: nil)[0] as? CommonPickerViewController
        
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

}
