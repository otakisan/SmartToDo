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
        self.detailView = self.createDetailView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func detailViewController() -> UIViewController? {
        
        return self.detailView
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
        vc?.completeDelegate = self.didFinishDetailView
        
        return vc
    }
}