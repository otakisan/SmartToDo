//
//  ToDoEditorV1ViewController.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorV1ViewController: UITableViewController {
    
    let completionDateCellId = "ToDoEditorCompletionDateTableViewCell"
    let createdDateCellId = "ToDoEditorCreatedDateTableViewCell"
    let detailCellId = "ToDoEditorDetailTableViewCell"
    let groupCellId = "ToDoEditorGroupTableViewCell"
    let idCellId = "ToDoEditorIdTableViewCell"
    let lastModifiedDateCellId = "ToDoEditorLastModifiedDateTableViewCell"
    let priorityCellId = "ToDoEditorPriorityTableViewCell"
    let progressCellId = "ToDoEditorProgressTableViewCell"
    let dueDataCellId = "ToDoEditorDueDateTableViewCell"
    let statusCellId = "ToDoEditorStatusTableViewCell"
    let tagCellId = "ToDoEditorTagTableViewCell"
    let titleCellId = "ToDoEditorTitleTableViewCell"
    
    var cellIds : [String] = []
    var todoId : String = ""
    var todoEntity : ToDoTaskEntity?
    
    @IBAction func touchUpInsideSaveButton(sender : AnyObject){
        print("save called.")
        self.save()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.intializeCellIds()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // ナビゲーションのライトボタンを構成
        self.configureRightBarButtonItem()

        // nibを登録
        self.registerNibs()
        
        // ロード
        self.loadOrCreateEntity()
    }
    
    private func intializeCellIds(){
        self.cellIds = []
        self.cellIds.append(self.titleCellId)
        self.cellIds.append(self.progressCellId)
        self.cellIds.append(self.dueDataCellId)
        self.cellIds.append(self.completionDateCellId)
    }
    
    /**
        ナビゲーションバーの右ボタンを構成します
    */
    private func configureRightBarButtonItem(){
        var barButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "touchUpInsideSaveButton:")
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    private func registerNibs() {
        for cellId in cellIds {
            self.tableView.registerNib(
                UINib(nibName: cellId, bundle: nil),
                forCellReuseIdentifier: cellId
            )
        }
    }
    
    private func loadOrCreateEntity(){
        if self.todoId == "" {
            self.initEntity()
        }
        else{
            self.loadEntityForId()
        }
    }
    
//    private func initViewData() {
//        self.initEntity()
//        self.setViewDataForEntity()
//    }
    
    private func initEntity(){
        self.todoEntity = self.todoEntity ?? TaskStoreService.createEntity()
        var entity = self.todoEntity!
        
        // TODO: デフォルト値一括適用の実装方式を考える
        entity.completionDate = NSDate()
        entity.createdDate = NSDate()
        entity.detail = ""
        entity.dueDate = NSDate()
        entity.group = ""
        entity.id = TaskStoreService.createId()
        entity.lastModifiedDate = NSDate()
        entity.priority = 0.0
        entity.progress = 0.0
        entity.status = ""
        entity.tag = ""
        entity.title = "init title"
    }
    
    private func loadEntityForId(){
        
    }
    
//    private func setViewDataForEntity(){
//        // この辺の単純列挙系は自動生成で
//        var entity = self.todoEntity!
//        self.setValueForCellId(self.completionDateCellId, value: entity.completionDate)
//        self.setValueForCellId(self.createdDateCellId, value: entity.createdDate)
//        self.setValueForCellId(self.detailCellId, value: entity.detail)
//        self.setValueForCellId(self.dueDataCellId, value: entity.dueDate)
//        self.setValueForCellId(self.groupCellId, value: entity.group)
//        self.setValueForCellId(self.idCellId, value: entity.id)
//        self.setValueForCellId(self.lastModifiedDateCellId, value: entity.lastModifiedDate)
//        self.setValueForCellId(self.priorityCellId, value: entity.priority)
//        self.setValueForCellId(self.progressCellId, value: entity.progress)
//        self.setValueForCellId(self.statusCellId, value: entity.status)
//        self.setValueForCellId(self.tagCellId, value: entity.tag)
//        self.setValueForCellId(self.titleCellId, value: entity.title)
//    }
    
    private func save() {
        var entity = self.entityFromViewData()
        //TaskStoreService.getManagedObjectContext().save(nil)
    }
    
    private func setEntityForViewData(entity : ToDoTaskEntity){
        // エンティティのメンバを列挙するAPIが分ければ、汎用的にできる
        // セル情報：ID文字列、デフォルト値が必要
        entity.completionDate = self.valueForCellId(self.completionDateCellId, defaultValue: NSDate())
        entity.createdDate = self.valueForCellId(self.createdDateCellId, defaultValue: NSDate())
        entity.detail = self.valueForCellId(self.detailCellId, defaultValue: "")
        entity.dueDate = self.valueForCellId(self.dueDataCellId, defaultValue: NSDate())
        entity.group = self.valueForCellId(self.groupCellId, defaultValue: "")
        entity.id = self.valueForCellId(self.idCellId, defaultValue: "")
        entity.lastModifiedDate = self.valueForCellId(self.lastModifiedDateCellId, defaultValue: NSDate())
        entity.priority = self.valueForCellId(self.priorityCellId, defaultValue: 0.0)
        entity.progress = self.valueForCellId(self.progressCellId, defaultValue: 0.0)
        entity.status = self.valueForCellId(self.statusCellId, defaultValue: "")
        entity.tag = self.valueForCellId(self.tagCellId, defaultValue: "")
        entity.title = self.valueForCellId(self.titleCellId, defaultValue: "")
    }
    
    private func entityFromViewData() -> ToDoTaskEntity {
        var entity = TaskStoreService.createEntity()
        self.setEntityForViewData(entity)
        
        // エンティティのメンバを列挙するAPIが分ければ、汎用的にできる
        // セル情報：ID文字列、デフォルト値が必要
//        entity.completionDate = self.valueForCellId(self.completionDateCellId, defaultValue: NSDate())
//        entity.createdDate = self.valueForCellId(self.createdDateCellId, defaultValue: NSDate())
//        entity.detail = self.valueForCellId(self.detailCellId, defaultValue: "")
//        entity.dueDate = self.valueForCellId(self.dueDataCellId, defaultValue: NSDate())
//        entity.group = self.valueForCellId(self.groupCellId, defaultValue: "")
//        entity.id = self.valueForCellId(self.idCellId, defaultValue: "")
//        entity.lastModifiedDate = self.valueForCellId(self.lastModifiedDateCellId, defaultValue: NSDate())
//        entity.priority = self.valueForCellId(self.priorityCellId, defaultValue: 0.0)
//        entity.progress = self.valueForCellId(self.progressCellId, defaultValue: 0.0)
//        entity.status = self.valueForCellId(self.statusCellId, defaultValue: "")
//        entity.tag = self.valueForCellId(self.tagCellId, defaultValue: "")
//        entity.title = self.valueForCellId(self.titleCellId, defaultValue: "")
//        
        return entity
    }
    
    private func valueForCellId(cellId : String) -> AnyObject? {
        
//        var cellValue : AnyObject? = nil
//        
//        var row = find(cellIds, cellId)
//        
//        if let rowIndex = row {
//            var indexPath = NSIndexPath(forRow: rowIndex, inSection: 0)
//            var cell = (self.tableView.cellForRowAtIndexPath(indexPath) as ToDoEditorBaseTableViewCell)
//            cellValue = cell.valueOfCell()
//        }
//        
//        return cellValue
        
        var cellValue : AnyObject? = nil
        
        if let cell = cellForCellId(cellId) {
            cellValue = cell.valueOfCell()
        }
        
        return cellValue
    }
    
    private func setValueForCellId(cellId : String, value : AnyObject) {
        if let cell = cellForCellId(cellId) {
            cell.setValueOfCell(value)
        }
    }
    
    private func cellForCellId(cellId : String) -> ToDoEditorBaseTableViewCell? {
        
        var cell : ToDoEditorBaseTableViewCell?
        var row = find(cellIds, cellId)
        
        if let rowIndex = row {
            var indexPath = NSIndexPath(forRow: rowIndex, inSection: 0)
            cell = (self.tableView.cellForRowAtIndexPath(indexPath) as ToDoEditorBaseTableViewCell?)
        }
        
        return cell
    }
    
    private func valueForCellId<TResult>(cellId : String, defaultValue : TResult) -> TResult {
        return (self.valueForCellId(cellId) as? TResult) ?? defaultValue
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
        return cellIds.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIds[indexPath.row], forIndexPath: indexPath) as ToDoEditorBaseTableViewCell
                
        // Configure the cell...
        if let entityData: AnyObject = self.todoEntity!.valueForKey(cell.bindingString()){
            cell.setValueOfCell(entityData)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // TODO: presentViewControllerを使う方式の問題なのか、遷移が遅い
        if let vc : UIViewController = (tableView.cellForRowAtIndexPath(indexPath) as ToDoEditorBaseTableViewCell).detailViewController() {
            
            // なぜかインジケーターを表示するコードを実装したら、presentViewControllerが速くなった
            var activityVC = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            activityVC.hidesWhenStopped = true
            activityVC.startAnimating()
            self.presentViewController(vc, animated: true, completion: {activityVC.stopAnimating()})
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
