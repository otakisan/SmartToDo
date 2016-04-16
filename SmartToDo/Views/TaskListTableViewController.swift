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
    lazy var prepareForSegueFuncTable : [String:(UIStoryboardSegue,AnyObject!)->Void] = self.initPrepareForSegueFuncTable()
    
    private func initPrepareForSegueFuncTable() -> [String:(UIStoryboardSegue,AnyObject!)->Void] {
        
        let funcTable : [String:(UIStoryboardSegue,AnyObject!)->Void] = [
            "showToDoEditorV1Segue" : self.prepareForShowToDoEditorV1Segue,
            "showToUnfinishedTaskListSegue" : self.prepareForShowToUnfinishedTaskListSegue
        ]
        
        return funcTable
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // タイトル
        self.setTitle()

        // ナビゲーションバーボタンを構成
        self.configureRightBarButtonItem()
        self.configureLeftBarButtonItem()
        
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
        var cell = tableView.dequeueReusableCellWithIdentifier("taskListTableViewCell", forIndexPath: indexPath) as! TaskListTableViewCell
        
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

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            let deleteLog = deleteTask(indexPath)
            self.showMessageDialog(NSLocalizedString("didDelete", comment: ""), message: String(format: NSLocalizedString("didDeleteMessage", comment: ""), deleteLog.id, deleteLog.title))
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    private func deleteTask(indexPath : NSIndexPath) -> (id : String, title: String) {
        
        // 先に行数の元となる配列から要素を削除し、numberOfRowsInSectionで削除後の行数を返却するようにする
        // 先に削除しないと、deleteRowsAtIndexPathsでエラーになる
        let rowIndexDeleting = indexPath.row
        let taskIdDeleting = tasks[rowIndexDeleting].id
        let taskTitleDeleting = tasks[rowIndexDeleting].title
        let taskEntityDeleting = tasks.removeAtIndex(rowIndexDeleting)
        
        // Delete the row from the data source
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
        // 念のため、前の処理が全部成功してから実際に削除する
        self.taskStoreService.deleteEntity(taskEntityDeleting)
        
        return (taskIdDeleting, taskTitleDeleting)
    }
    
    private func showMessageDialog(title : String, message : String) {
        ViewUtility.showMessageDialog(self, title: title, message: message)
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
        
        self.prepareForSegueFuncTable[segue.identifier!]!(segue, sender)
    }
    
    private func prepareForShowToDoEditorV1Segue(segue: UIStoryboardSegue, sender: AnyObject!){
        
        // セルをタップした場合は、そのセルからIDを取得し、taskIdにセット
        // 新規追加：タスクIDは空。締切日の初期値を渡す
        var vc = segue.destinationViewController as! ToDoEditorV1ViewController
        if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
            
            var indexPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
            vc.taskId = (self.tableView.cellForRowAtIndexPath(indexPath) as! TaskListTableViewCell).taskId
        }else{
            vc.initialValues = ["dueDate":self.dayOfTask]
        }
        
        // 遷移先のレフトボタンを構成する（自分に制御を移すため）
        if var nvc = self.navigationController {
            var bckItem = UIBarButtonItem(title: NSLocalizedString("BackToList", comment: ""), style: UIBarButtonItemStyle.Bordered, target: self, action: "didBack:")
            
            vc.navigationItem.leftBarButtonItem = bckItem
        }
    }

    private func prepareForShowToUnfinishedTaskListSegue(segue: UIStoryboardSegue, sender: AnyObject!){
        
        // 遷移先のレフトボタンを構成する（自分に制御を移すため）
        var vc = segue.destinationViewController as! UnfinishedTaskListTableViewController
        vc.dueDateOfCopy = self.dayOfTask
        
        if var nvc = self.navigationController {
            var bckItem = UIBarButtonItem(title: NSLocalizedString("BackToList", comment: ""), style: UIBarButtonItemStyle.Bordered, target: self, action: "didBack:")
            
            vc.navigationItem.leftBarButtonItem = bckItem
        }
    }
    
    @IBAction private func didBack(sender : AnyObject){
        self.navigationController?.popViewControllerAnimated(true)
        
        // 保存しなかった変更は消す
        self.taskStoreService.rollback()
        
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
        let datePartOfNow = DateUtility.firstEdgeOfDay(NSDate())
        if datePartOfNow.compare(self.dayOfTask) == NSComparisonResult.OrderedAscending ||
        datePartOfNow.compare(self.dayOfTask) == NSComparisonResult.OrderedSame
        {
            self.appendCopyButtonIntoNavigationBar()
            self.appendAddButtonIntoNavigationBar()
        }
    }
    
    private func appendAddButtonIntoNavigationBar() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "touchUpInsideAddButton:")

        self.appendRightBarButtonItem(addBarButtonItem)
    }
    
    private func appendCopyButtonIntoNavigationBar() {        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "touchUpInsideCopyButton:")
        
        self.appendRightBarButtonItem(barButton)
    }
    
    private func appendEditButtonIntoNavigationBar() {
        var inoutparam : [UIBarButtonItem]? = self.navigationItem.leftBarButtonItems
        self.appendBarButtonItem(&inoutparam, barButtonItem: self.editButtonItem())
    }
    
    private func appendRightBarButtonItem(barButtonItem : UIBarButtonItem) {
        
        if self.navigationItem.rightBarButtonItems != nil {
            self.navigationItem.rightBarButtonItems!.append(barButtonItem)
        }
        else{
            self.navigationItem.rightBarButtonItems = [barButtonItem]
        }
    }
    
    private func todayOrFuture() -> Bool {
        let datePartOfNow = DateUtility.firstEdgeOfDay(NSDate())
        return datePartOfNow.compare(self.dayOfTask) == NSComparisonResult.OrderedAscending ||
            datePartOfNow.compare(self.dayOfTask) == NSComparisonResult.OrderedSame
    }
    
    private func configureLeftBarButtonItem(){
        if self.todayOrFuture() {
            self.appendEditButtonIntoNavigationBar()
        }
    }
    
    private func appendBarButtonItem(inout barButtonItems : [UIBarButtonItem]?, barButtonItem : UIBarButtonItem){
        if barButtonItems != nil {
            barButtonItems!.append(barButtonItem)
        }
        else{
            barButtonItems = [barButtonItem]
        }
    }
    
    private func setTitle() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        self.navigationItem.title = dateFormatter.stringFromDate(self.dayOfTask)
    }

    @IBAction func touchUpInsideAddButton(sender : AnyObject){
        print("add called.", terminator: "")
        self.performSegueWithIdentifier("showToDoEditorV1Segue", sender: self)
    }

    @IBAction func touchUpInsideCopyButton(sender : AnyObject){
        self.performSegueWithIdentifier("showToUnfinishedTaskListSegue", sender: self)
    }
}
