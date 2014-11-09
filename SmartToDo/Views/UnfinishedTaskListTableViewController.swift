//
//  UnfinishedTaskListTableViewController.swift
//  SmartToDo
//
//  Created by takashi on 2014/11/08.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class UnfinishedTaskListTableViewController: UITableViewController {

//    let yesterdayTasksKey = "yesterdayTasks"
//    let lastWeekTasksKey = "lastWeekTasks"
//    let last4WeeksTasksKey = "last4WeeksTasks"
    
    var taskStoreService : TaskStoreService = TaskStoreService()
//    var tasks : [String:[ToDoTaskEntity]] = [:]
    
    // セクションごとの情報はまとめて管理 -> タプル？
    var tasks : [(headerTitle:String, tasks:[ToDoTaskEntity])] = []
    var dueDateOfCopy = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.tableView.registerNib(UINib(nibName: "UnfinishedTaskListTableViewCell", bundle: nil), forCellReuseIdentifier: "UnfinishedTaskListTableViewCell")

        self.configureRightBarButtonItem()
        
        self.setTitle()
        
        self.initUnfinisedTasks()
    }
    
    private func initUnfinisedTasks() {
        
        self.tasks.removeAll(keepCapacity: true)
        
        // タスクリストの構築（格納する順番がそのまま表示順）
        // 表示順の可変を実装する場合、データとしての保持と表示用の配列の保持を分けて考える必要があるかもしれない
        
        // 昨日
        var now = NSDate()
        var yesterday = now.dateByAddingTimeInterval(-1 * 24 * 3600)
        var yesterdayTasks : [ToDoTaskEntity] = self.taskStoreService.getTasksUnfinished(yesterday, toDate: yesterday)
        var arrayElement = (headerTitle:"Yesterday", tasks:yesterdayTasks)
        self.tasks += [arrayElement]
        
        // １週間以内（２〜７日間以内）
        var toLastWeek = yesterday.dateByAddingTimeInterval(-1 * 24 * 3600)
        var fromLastWeek = now.dateByAddingTimeInterval(-1 * 7 * 24 * 3600)
        var lastWeekTasks = self.taskStoreService.getTasksUnfinished(fromLastWeek, toDate: toLastWeek)
        self.tasks += [(headerTitle:"Last Week", tasks:lastWeekTasks)]
        
        // 約１ヶ月以内（４w、８〜２８日間以内）
        var toLast4Weeks = fromLastWeek.dateByAddingTimeInterval(-1 * 24 * 3600)
        var fromLast4Weeks = now.dateByAddingTimeInterval(-4 * 7 * 24 * 3600)
        var last4WeeksTasks = self.taskStoreService.getTasksUnfinished(fromLast4Weeks, toDate: toLast4Weeks)
        self.tasks += [(headerTitle: "Last 4 Weeks", tasks:last4WeeksTasks)]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.tasks.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
//        return self.tasks.values.array[section].count
        return self.tasks[section].tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UnfinishedTaskListTableViewCell", forIndexPath: indexPath) as UnfinishedTaskListTableViewCell

        // Configure the cell...
        cell.refreshDisplay(self.tasks[indexPath.section].tasks[indexPath.row])

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tasks[section].headerTitle
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showToDoEditorV1FromUnfinishedTaskListSegue", sender: self)
    }
//    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return "section footer \(section)"
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
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
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        var vc = segue.destinationViewController as ToDoEditorV1ViewController
        vc.readOnly = true
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow() {
            
            var indexPath = NSIndexPath(forRow: selectedIndexPath.row, inSection: selectedIndexPath.section)
            vc.taskId = (self.tableView.cellForRowAtIndexPath(indexPath) as UnfinishedTaskListTableViewCell).toDoTaskEntity?.id ?? ""
        }
    }
    
    @IBAction func touchUpInsideCopyButton(sender : AnyObject){
        // 選択したタスクの内容IDと締切日を変更して、新規登録
        var copyCount = self.copyTask()
        self.showMessageDialog("Copy", message: "\(copyCount) task(s) copied.")
    }
    
    private func showMessageDialog(title : String, message : String) {
        ViewUtility.showMessageDialog(self, title: title, message: message)
    }
    
    private func copyTask() -> Int {
        
        var copyCount = 0
        var sectionCount = self.tableView.numberOfSections()
        for sectionIndex in 0 ..< sectionCount {
            var rowCount = self.tableView.numberOfRowsInSection(sectionIndex)
            for rowIndex in 0 ..< rowCount {
                var indexPath = NSIndexPath(forRow: rowIndex, inSection: sectionIndex)
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? UnfinishedTaskListTableViewCell{
                    if cell.copyTargetSwitch.on && cell.toDoTaskEntity != nil {
                        copyTask(cell.toDoTaskEntity!)
                        
                        copyCount++
                    }
                }
            }
        }
        
        return copyCount
    }
    
    private func copyTask(srcEntity : ToDoTaskEntity) {
        var copiedEntity = self.taskStoreService.copyEntity(srcEntity)
        self.adjustCopiedTask(copiedEntity)
        
        self.taskStoreService.insertEntity(copiedEntity)
    }
    
    private func adjustCopiedTask(entity : ToDoTaskEntity) {
        entity.dueDate = self.dueDateOfCopy
    }

    private func configureRightBarButtonItem(){
        self.appendCopyButtonIntoNavigationBar()
    }

    private func appendCopyButtonIntoNavigationBar() {
        var barButton = UIBarButtonItem(title: "Copy", style: UIBarButtonItemStyle.Plain, target: self, action: "touchUpInsideCopyButton:")
        
        self.appendRightBarButtonItem(barButton)
    }
    
    private func appendRightBarButtonItem(barButtonItem : UIBarButtonItem) {
        
        if self.navigationItem.rightBarButtonItems != nil {
            self.navigationItem.rightBarButtonItems!.append(barButtonItem)
        }
        else{
            self.navigationItem.rightBarButtonItems = [barButtonItem]
        }
    }

    private func setTitle() {
        self.navigationItem.title = "Unfinished"
    }
}
