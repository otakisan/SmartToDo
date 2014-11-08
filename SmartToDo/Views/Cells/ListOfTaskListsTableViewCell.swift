//
//  ListOfTaskListsTableViewCell.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/08.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ListOfTaskListsTableViewCell: UITableViewCell {

    lazy var titleDateFormatter : NSDateFormatter = self.createTitleDateFormatter()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshDisplay(date : NSDate) {
        self.textLabel.attributedText = self.getTitleLabelText(date)
        self.detailTextLabel?.text = self.getDetailLabelText(date)
    }
    
    private func createTitleDateFormatter() -> NSDateFormatter {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        return dateFormatter
    }
    
    private func getCountOfTasksLeft(date : NSDate) -> Int {
        return Int(arc4random_uniform(100))
    }
    
    private func getCountOfTasks(date : NSDate) -> Int {
        return Int(arc4random_uniform(100))
    }
    
    private func getTitleLabelText(date : NSDate) -> NSAttributedString {
        
        // NSAttributedStringでも良いけど、装飾したいときとそうでないときがあるので可変なほうにする
        var title = NSMutableAttributedString(string: self.titleDateFormatter.stringFromDate(date))
        
        /* NSAttributedStringを使用するとすれば下記のようになる
        var title = NSAttributedString(
            string: self.titleDateFormatter.stringFromDate(date),
            attributes: [NSUnderlineStyleAttributeName:NSUnderlineStyle.StyleSingle.rawValue]
        )
        */
        
        if DateUtility.isEqualDateComponent(date, date2: NSDate()) {
            
            // 当日であれば装飾
            title.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, countElements(title.string)))
        }
        
        return title
    }
    
    private func getDetailLabelText(date : NSDate) -> String {
        let totalCount = self.getCountOfTasks(date)
        let leftCount = self.getCountOfTasksLeft(date)
        
        return "\(leftCount)/\(totalCount)"
    }
}
