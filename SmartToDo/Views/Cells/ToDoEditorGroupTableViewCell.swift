//
//  ToDoEditorGroupTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/02.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorGroupTableViewCell: ToDoEditorBaseTableViewCell {

    lazy var dataLists : [[String]] = self.createDataSource()

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
    
    override func setValueOfCell(value: AnyObject) {
        if let entityData = value as? String {
            self.groupLabel.text = entityData
        }
    }
    
    override func bindingString() -> String {
        return "group"
    }

    func completeDelegate() -> ((UIView) -> Void)? {
        return self.didFinishDetailView
    }
    
    func didFinishDetailView(detailView : UIView){
        
        if let view = detailView as? UIPickerView {
            var selectedIndex = view.selectedRowInComponent(0)
            if selectedIndex >= 0 {
                var valueString = self.dataLists[0][selectedIndex]
                self.groupLabel?.text = valueString
            }
        }
    }
    
    override func createDetailView() -> UIViewController? {
        
        var vc = self.loadDetailView()
        vc?.setDataSource(self.dataSource())
        vc?.setViewValue(self.detailViewInitValue()!)
        vc?.setCompleteDeleage(self.completeDelegate())
        
        return vc
    }
    
    func loadDetailView() -> CommonPickerViewController? {
        
        var vc = NSBundle.mainBundle().loadNibNamed("CommonPickerViewController", owner: nil, options: nil)[0] as? CommonPickerViewController
        
        return vc
    }
    
    func detailViewInitValue() -> AnyObject? {
        return self.groupLabel.text ?? ""
    }
    
    func dataSource() -> [[String]] {
        return dataLists
    }
    
    func createDataSource() -> [[String]] {
        return [["group1", "group2", "init group"]]
    }
    
}
