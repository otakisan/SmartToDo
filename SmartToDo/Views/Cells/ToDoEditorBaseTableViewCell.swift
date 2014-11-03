//
//  ToDoEditorBaseTableViewCell.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorBaseTableViewCell: UITableViewCell {

    var detailView : UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    /**
        詳細画面を返却します
    */
    func detailViewController() -> UIViewController? {
        if self.detailView == nil {
            self.detailView = self.createDetailView()
        }
        return self.detailView
    }
    
//    func createDetailView() -> UIViewController? {
//        return nil
//    }
    
    func valueOfCell() -> AnyObject? {
        return nil
    }
    
    func setValueOfCell(value : AnyObject) {
        
    }
    
    func bindingString() -> String {
        return ""
    }

    func createDetailView() ->UIViewController?{
        return nil
    }
//    func createDetailView() -> UIViewController? {
//        
//        var vc = self.loadDetailView()
//        if let initValue: AnyObject = self.detailViewInitValue() {
//            vc?.setViewValue(initValue)
//        }
//        //        vc?.textView.text = self.detailViewInitValue()
//        vc?.completeDelegate = self.completeDelegate()
//        
//        return vc
//    }
// 
    
//    func loadDetailView() -> UIViewController? {
//        return nil
//    }
//    
//    func detailViewInitValue() -> AnyObject? {
//        return nil
//    }
//    
//    func completeDelegate() -> ((UIView) -> Void)?{
//        return nil
//    }
    
//    func didFinishDetailView(detailView : UIView){
//    }

}
