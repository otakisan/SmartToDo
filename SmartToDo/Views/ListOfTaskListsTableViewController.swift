//
//  ListOfTaskListsTableViewController.swift
//  SmartToDo
//
//  Created by takashi on 2014/09/15.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ListOfTaskListsTableViewController: UITableViewController {
    
    lazy var listOfDays : [NSDate] = self.createDayList()
    var daysBeforeAndAfter = 7
    var taskStoreService : TaskStoreService = TaskStoreService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerNib(UINib(nibName: "ListOfTaskListsTableViewCell", bundle: nil), forCellReuseIdentifier: "ListOfTaskListsTableViewCell")
        
        self.setTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.listOfDays.count
    }
    
    private func createDayList() -> [NSDate] {
        
        var dateList : [NSDate] = []
        
        var today = NSDate()
        for dayDiff in -1 * self.daysBeforeAndAfter ... self.daysBeforeAndAfter {
            var timeInterval = NSTimeInterval(dayDiff * 24 * 3600)
            dateList.append(today.dateByAddingTimeInterval(timeInterval))
        }
        
        return dateList
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListOfTaskListsTableViewCell", forIndexPath: indexPath) as ListOfTaskListsTableViewCell
            
        // セルを構成する
        let taskDate = self.listOfDays[indexPath.row]
        cell.taskCount = self.taskStoreService.countByDueDate(taskDate)
        cell.taskLeftCount = self.taskStoreService.countUnfinishedByDueDate(taskDate, toDueDate: taskDate)
        cell.refreshDisplay(taskDate)
        
        // 当日を出す場合、初期表示で当日を先頭にするが、
        // それよりも前にも日がある。
        // この関数は非表示->表示で呼ばれるような感じだから難しいかも。
//        if self.isEqualDate(taskDate, date2: NSDate()) {
//            self.displayTodayCell()
//        }
        
        return cell
    }
    
    private func displayTodayCell(){
        let todayIndexPath = NSIndexPath(forRow: self.listOfDays.count / 2, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(todayIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
    }
    
    private func setTitle(){
        // 表示期間をタイトル表示する ちょっと日付の値を出力するだけで、このような実装量が必要になる？
        let dayInterval = 60 * 60 * 24
        let fromDate = NSDate(timeIntervalSinceNow: (NSTimeInterval)(dayInterval * self.daysBeforeAndAfter * -1))
        let fromComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: fromDate)
        let from = String(format: "%02d/%02d", fromComponents.month, fromComponents.day)
        
        let toDate = NSDate(timeIntervalSinceNow: (NSTimeInterval)(dayInterval * self.daysBeforeAndAfter))
        let toComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.MonthCalendarUnit | NSCalendarUnit.DayCalendarUnit, fromDate: toDate)
        let to = String(format: "%02d/%02d", toComponents.month, toComponents.day)
        
        self.navigationItem.title = "\(from) - \(to)"
        
//        self.navigationItem.title = "\(fromComponents.month)/\(fromComponents.day) - \(toComponents.month)/\(toComponents.day)"
        
//        self.navigationItem.title = String(format: NSLocalizedString("ListOfTaskListsTitle", comment: "comment"), self.daysBeforeAndAfter)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showTaskListSegue", sender: self.tableView.cellForRowAtIndexPath(indexPath))
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if var vc = segue.destinationViewController as? TaskListTableViewController {
            
            if let cell = sender as? ListOfTaskListsTableViewCell {
                vc.dayOfTask = cell.dateOfTaskList!
            }
            
            self.configureDstLeftButton(vc)
        }
    }

    func configureDstLeftButton(vc : UIViewController){
        
        // 遷移先のレフトボタンを構成する（自分に制御を移すため）
        if var nvc = self.navigationController {
            var bckItem = UIBarButtonItem(title: NSLocalizedString("BackToListOfLists", comment: ""), style: UIBarButtonItemStyle.Bordered, target: self, action: "didBack:")
           vc.navigationItem.leftBarButtonItem = bckItem
        }
    }
    
    @IBAction private func didBack(sender : AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
        self.reloadTaskList()
    }
    
    func reloadTaskList(){
        self.listOfDays = self.createDayList()
        self.tableView.reloadData()
    }

    /**
    Quick Look に表示する値を返却する
    */
    func debugQuickLookObject() -> AnyObject? {
        return "List Of Days : \(self.listOfDays.count)"
    }
}
