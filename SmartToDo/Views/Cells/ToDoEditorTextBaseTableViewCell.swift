//
//  ToDoEditorTextBaseTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/03.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorTextBaseTableViewCell: ToDoEditorBaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func valueOfCell() -> AnyObject? {
        return self.textValueOfCell()
    }
    
    func textValueOfCell() -> String {
        return ""
    }
    
    override func setValueOfCell(value: AnyObject) {
        if let entityData = value as? String {
            self.setTextValueOfCell(entityData)
        }
    }
    
    func setTextValueOfCell(textValue : String) {
        
    }
    
    func completeDelegate() -> ((UIView) -> Void)? {
        return self.didFinishDetailView
    }
    
    func didFinishDetailView(detailView : UIView){
        if let view = detailView as? UITextView{
            self.didFinishTextView(view)
        }
    }
    
    func didFinishTextView(textView : UITextView){
        // Subclass Must Implement
    }
    
    override func createDetailView() -> UIViewController? {
        
        var vc = self.loadDetailView()
        vc?.setViewValue(self.detailViewInitValue()!)
        vc?.setCompleteDeleage(self.completeDelegate())
        
        return vc
    }
    
    func loadDetailView() -> CommonTextViewController? {
        
        var vc = NSBundle.mainBundle().loadNibNamed("CommonTextViewController", owner: CommonTextViewController(), options: nil)[0] as? CommonTextViewController
        
        return vc
    }
    
    func detailViewInitValue() -> AnyObject? {
        return ""
    }
}
