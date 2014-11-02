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

    var detailView : CommonTextViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.detailView = self.createDetailView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func detailViewController() -> UIViewController? {
        if self.detailView == nil {
            self.detailView = self.createDetailView()
        }
        return self.detailView
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
    
    func didFinishDetailView(textView : UITextView){
        self.titleLabel?.text = textView.text
    }
    
    private func loadDetailView() -> CommonTextViewController? {
        
        var vc = NSBundle.mainBundle().loadNibNamed("CommonTextViewController", owner: CommonTextViewController(), options: nil)[0] as? CommonTextViewController
        
        return vc
    }
    
    private func createDetailView() -> CommonTextViewController? {
        
        var vc = self.loadDetailView()
        vc?.textView.text = self.detailViewInitValue()
        vc?.completeDelegate = self.didFinishDetailView
        
        return vc
    }
    
    func detailViewInitValue() -> String {
        return self.titleLabel.text ?? ""
    }
}
