//
//  ToDoEditorTitleTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorTitleTableViewCell: ToDoEditorBaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func valueOfCell() -> AnyObject? {
        return self.titleLabel.text
    }
    
    override func setValueOfCell(value: AnyObject) {
        if let entityData = value as? String {
            self.titleLabel.text = entityData
        }
    }
    
    override func bindingString() -> String {
        return "title"
    }
    
    func completeDelegate() -> ((UIView) -> Void)? {
        return self.didFinishDetailView
    }
    
    func didFinishDetailView(detailView : UIView){
        if let view = detailView as? UITextView{
            self.titleLabel?.text = view.text
        }
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
        return self.titleLabel.text ?? ""
    }
}
