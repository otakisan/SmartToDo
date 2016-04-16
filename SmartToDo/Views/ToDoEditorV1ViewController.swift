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
    let priorityCellId = "ToDoEditorPriorityV2TableViewCell"
    let progressCellId = "ToDoEditorProgressV2TableViewCell"
    let dueDateCellId = "ToDoEditorDueDateTableViewCell"
    let statusCellId = "ToDoEditorStatusTableViewCell"
    let tagCellId = "ToDoEditorTagV2TableViewCell"
    let titleCellId = "ToDoEditorTitleTableViewCell"
    
    var cellIds : [String] = []
    var taskId : String = ""
    var todoEntity : ToDoTaskEntity?
    var initialValues : [String:AnyObject] = [:]
    lazy var taskStore = TaskStoreService()
    var readOnly = false
    
    @IBAction func touchUpInsideSaveButton(sender : AnyObject){
        print("save called.", terminator: "")
        self.saveWithCompletionMessage()
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
        // リストへの格納順が表示順
        self.cellIds = []
        self.cellIds.append(self.titleCellId)
        self.cellIds.append(self.groupCellId)
        self.cellIds.append(self.priorityCellId)
        self.cellIds.append(self.statusCellId)
        self.cellIds.append(self.progressCellId)
//        self.cellIds.append(self.dueDateCellId)
        self.cellIds.append(self.detailCellId)
//        self.cellIds.append(self.completionDateCellId)
        self.cellIds.append(self.tagCellId)
        self.cellIds.append(self.lastModifiedDateCellId)
        self.cellIds.append(self.createdDateCellId)
        self.cellIds.append(self.idCellId)
    }
    
    /**
        ナビゲーションバーの右ボタンを構成します
    */
    private func configureRightBarButtonItem(){
        if !self.readOnly {
            self.appendSaveButtonIntoNavigationBar()
        }
    }
    
    private func appendSaveButtonIntoNavigationBar() {
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: "touchUpInsideSaveButton:")
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
        if self.taskId == "" || !self.loadEntityForId(){
            self.initEntity()
        }
    }
    
    private func initEntity(){
        self.todoEntity = self.todoEntity ?? TaskStoreService.createEntity()
        let entity = self.todoEntity!
        
        // TODO: デフォルト値一括適用の実装方式を考える
        // Saveしないでバックで戻ったときは、新規分の破棄が必要
        self.setDefaultInitValue(entity)
        
        // 外部から初期値の指定があれば、上書きで設定する
        for pair in self.initialValues {
            if entity.valueForKey(pair.0) != nil {
                entity.setValue(pair.1, forKey: pair.0)
            }
        }
    }
    
    private func setDefaultInitValue(entity : ToDoTaskEntity){
        entity.completionDate = NSDate(timeIntervalSince1970: 0)
        entity.createdDate = NSDate()
        entity.detail = "DefaultDetail".localized()
        entity.dueDate = NSDate()
        entity.group = "DefaultGroup".localized()
        entity.id = TaskStoreService.createId()
        entity.lastModifiedDate = NSDate()
        entity.priority = 3
        entity.progress = 0.0
        entity.status = "DefaultStatus".localized()
        entity.tag = "DefaultTag".localized()
        entity.title = "DefaultTitle".localized()
    }
    
    private func loadEntityForId() -> Bool {
        self.todoEntity = self.taskStore.findById(self.taskId)
        return self.todoEntity != nil
    }
    
    private func save() {
        
        if let entity = self.todoEntity {
            
            self.setEntityForViewData(entity)
            
            if TaskStoreService.getManagedObjectContext().objectRegisteredForID(entity.objectID) == nil {
                TaskStoreService.getManagedObjectContext().insertObject(entity)
            }
        }
        
        do {
            try TaskStoreService.getManagedObjectContext().save()
        } catch _ {
        }
    }
    
    private func saveWithCompletionMessage(message : String = "") {
        self.save()
        self.showSavedMessageDialog(message)
    }
    
    private func showSavedMessageDialog(detail : String){
        let id : String = self.todoEntity?.id ?? ""
        let title : String = self.todoEntity?.title ?? ""
        
        self.showMessageDialog("didSave".localized([detail]), message: "didSaveMessage".localized([id, title]))
    }
    
    private func showMessageDialog(title : String, message : String) {
        self.showNavigationPrompt(title, message: message, displayingTime: 1.0)
        //ViewUtility.showMessageDialog(self, title: title, message: message)
    }
    
    private func showNavigationPrompt(title : String, message : String, displayingTime: NSTimeInterval) {
        self.navigationItem.prompt = "\(title) : \(message)"
        
        // リピートせず１回のみの実行とするため、invalidateは不要
        NSTimer.scheduledTimerWithTimeInterval(displayingTime, target: self, selector: Selector("dismissNavigationPrompt"), userInfo: nil, repeats: false)
    }
    
    func dismissNavigationPrompt() {
        self.navigationItem.prompt = nil
    }

    private func setEntityForViewData(entity : ToDoTaskEntity){
        // エンティティのメンバを列挙するAPIが分ければ、汎用的にできる
        // セル情報：ID文字列、デフォルト値が必要
        // セルが破棄されてしまっている場合には、現在の値そのままとする（破棄時にエンティティの値を更新している）
        entity.completionDate = self.valueForCellId(self.completionDateCellId, defaultValue: entity.completionDate)
        entity.createdDate = self.valueForCellId(self.createdDateCellId, defaultValue: entity.createdDate)
        entity.detail = self.valueForCellId(self.detailCellId, defaultValue: entity.detail)
        entity.dueDate = self.valueForCellId(self.dueDateCellId, defaultValue: entity.dueDate)
        entity.group = self.valueForCellId(self.groupCellId, defaultValue: entity.group)
        entity.id = self.valueForCellId(self.idCellId, defaultValue: entity.id)
        entity.lastModifiedDate = self.valueForCellId(self.lastModifiedDateCellId, defaultValue: entity.lastModifiedDate)
        entity.priority = self.valueForCellId(self.priorityCellId, defaultValue: entity.priority)
        entity.progress = self.valueForCellId(self.progressCellId, defaultValue: entity.progress)
        entity.status = self.valueForCellId(self.statusCellId, defaultValue: entity.status)
        entity.tag = self.valueForCellId(self.tagCellId, defaultValue: entity.tag)
        entity.title = self.valueForCellId(self.titleCellId, defaultValue: entity.title)
    }
    
    private func valueForCellId(cellId : String) -> AnyObject? {
        
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
        let row = cellIds.indexOf(cellId)
        
        if let rowIndex = row {
            let indexPath = NSIndexPath(forRow: rowIndex, inSection: 0)
            cell = (self.tableView.cellForRowAtIndexPath(indexPath) as? ToDoEditorBaseTableViewCell)
        }
        
        return cell
    }
    
    private func valueForCellId<TResult>(cellId : String, defaultValue : TResult) -> TResult {
        return (self.valueForCellId(cellId) as? TResult) ?? defaultValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // メモリ警告のため、強制的に保存する
        self.saveWithCompletionMessage("MemoryWarningMessage".localized())
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIds[indexPath.row], forIndexPath: indexPath) as! ToDoEditorBaseTableViewCell
                
        // Configure the cell...
        if let entityData: AnyObject = self.todoEntity?.valueForKey(cell.bindingString()){
            cell.setValueOfCell(entityData)
            cell.refreshAccessoryType()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // TODO: presentViewControllerを使う方式の問題なのか、遷移が遅い
        if let vc : UIViewController = (tableView.cellForRowAtIndexPath(indexPath) as! ToDoEditorBaseTableViewCell).detailViewController() {
            
            // なぜかインジケーターを表示するコードを実装したら、presentViewControllerが速くなった
//            var activityVC = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
//            activityVC.hidesWhenStopped = true
//            activityVC.startAnimating()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
//            self.navigationController?.setNavigationBarHidden(true, animated: false)
//            self.presentViewController(vc, animated: true, completion: {activityVC.stopAnimating()})
        }
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let editorCell = cell as? ToDoEditorBaseTableViewCell{
            self.todoEntity?.setValue(editorCell.valueOfCell(), forKey: editorCell.bindingString())
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }


}
