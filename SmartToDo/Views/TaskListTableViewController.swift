//
//  TaskListTableViewController.swift
//  SmartToDo
//
//  Created by takashi on 2014/09/15.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    var taskStoreService : TaskStoreService = TaskStoreService()
    var tasks : [ToDoTaskEntity] = []
    var dayOfTask = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // タイトル
        self.setTitle()

        // ナビゲーションバー右ボタンを構成
        self.configureRightBarButtonItem()
        
        self.tableView.registerNib(UINib(nibName: "TaskListTableViewCell", bundle: nil), forCellReuseIdentifier: "taskListTableViewCell")
        
        //        self.taskStoreService.clearAllTasks() // テスト上、初期化したい場合はコールする
 
        // 本リストに列挙するタスクを取得
        self.tasks = self.taskStoreService.getTasks(self.dayOfTask)
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
        return self.tasks.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("taskListTableViewCell", forIndexPath: indexPath) as TaskListTableViewCell
        
        // Configure the cell...
        let task = self.tasks[indexPath.row]
        cell.taskTitleLabel.text = task.title
        cell.taskProgressView.progress = Float(task.progress)
        cell.taskId = task.id
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.performSegueWithIdentifier("showToDoEditorSegue", sender: self)
        self.performSegueWithIdentifier("showToDoEditorV1Segue", sender: self)
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
        // セルをタップした場合は、そのセルからIDを取得し、taskIdにセット
        // 新規追加：タスクIDは空。締切日の初期値を渡す
        var vc = segue.destinationViewController as ToDoEditorV1ViewController
        if let selectedIndex = self.tableView.indexPathForSelectedRow()?.row {
            
            var indexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
            vc.taskId = (self.tableView.cellForRowAtIndexPath(indexPath) as TaskListTableViewCell).taskId
        }else{
            vc.initialValues = ["dueDate":self.dayOfTask]
        }
        
        // 遷移先のレフトボタンを構成する（自分に制御を移すため）
        if var nvc = self.navigationController {
            var bckItem = UIBarButtonItem(title: "BackToList", style: UIBarButtonItemStyle.Bordered, target: self, action: "didBack:")
            
            vc.navigationItem.leftBarButtonItem = bckItem
        }
    }
    
    @IBAction private func didBack(sender : AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
        self.reloadTaskList()
    }
    
    func reloadTaskList(){
        self.tasks = self.taskStoreService.getTasks(self.dayOfTask)
        self.tableView.reloadData()
    }
    
    /**
    ナビゲーションバーの右ボタンを構成します
    */
    private func configureRightBarButtonItem(){
        var datePartOfNow = DateUtility.firstEdgeOfDay(NSDate())
        if datePartOfNow.compare(self.dayOfTask) == NSComparisonResult.OrderedAscending ||
        datePartOfNow.compare(self.dayOfTask) == NSComparisonResult.OrderedSame
        {
            self.appendCopyButtonIntoNavigationBar()
            self.appendAddButtonIntoNavigationBar()
        }
    }
    
    private func appendAddButtonIntoNavigationBar() {
        var barButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "touchUpInsideAddButton:")
        
        self.appendRightBarButtonItem(barButton)
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
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.navigationItem.title = dateFormatter.stringFromDate(self.dayOfTask)
    }

    @IBAction func touchUpInsideAddButton(sender : AnyObject){
        print("add called.")
        self.performSegueWithIdentifier("showToDoEditorV1Segue", sender: self)
    }

    @IBAction func touchUpInsideCopyButton(sender : AnyObject){
        self.performSegueWithIdentifier("showToDoEditorV1Segue", sender: self)
    }
}
