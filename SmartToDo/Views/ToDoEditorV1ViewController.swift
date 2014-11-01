//
//  ToDoEditorV1ViewController.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/26.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class ToDoEditorV1ViewController: UITableViewController {
    
    let cellIds : [String] = [
        "ToDoEditorTitleTableViewCell",
        "ToDoEditorProgressTableViewCell",
        "ToDoEditorDueDateTableViewCell"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

//        self.tableView.registerNib(
//            UINib(nibName: "ToDoEditorTableViewCell", bundle: nil),
//            forCellReuseIdentifier: "toDoEditorTitleTableViewCell"
//        )

        for cellId in cellIds{
            self.tableView.registerNib(
                UINib(nibName: cellId, bundle: nil),
                forCellReuseIdentifier: cellId
            )
        }

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
        
        return cell
    }
    
    var lastRow : Int = 0
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        if let vc : CommonDatePickerViewController? = (tableView.cellForRowAtIndexPath(indexPath) as ToDoEditorBaseTableViewCell).detailViewController() as? CommonDatePickerViewController{
//            
//            vc!.completeDelegate = self.completeDatePicker
//            lastRow = indexPath.row
//            
//            self.presentViewController(vc!, animated: true, completion: nil)
//        }
        
        // TODO: presentViewControllerを使う方式の問題なのか、遷移が遅い
        if let vc : UIViewController? = (tableView.cellForRowAtIndexPath(indexPath) as ToDoEditorBaseTableViewCell).detailViewController() {
            
            self.presentViewController(vc!, animated: true, completion: nil)
        }
    }
    
//    func completeDatePicker(p : UIDatePicker){
//        if let cell : ToDoEditorBaseTableViewCell = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: lastRow, inSection: 0)) as? ToDoEditorBaseTableViewCell){
//            print(p.description)
//        }
//    }
    
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
