//
//  TaskStoreService.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/20.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit
import CoreData

class TaskStoreService: NSObject {
    
    /**
    ManagedObjectContext取得
    
    :returns: ManagedObjectContext
    */
    class func getManagedObjectContext() -> NSManagedObjectContext {
        
        var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context : NSManagedObjectContext = appDel.managedObjectContext!
        
        return context
    }
    
    class func getManagedObjectModel() -> NSManagedObjectModel {
        
        var appDel : AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context : NSManagedObjectModel = appDel.managedObjectModel
        
        return context
    }
    
    /**
    ToDoタスクエンティティを生成します
    
    :returns: ToDoタスクエンティティ
    */
    class func createEntity() -> ToDoTaskEntity {
        var context : NSManagedObjectContext = TaskStoreService.getManagedObjectContext()
        let ent = NSEntityDescription.entityForName("ToDoTaskEntity", inManagedObjectContext: context)
        
        return ToDoTaskEntity(entity: ent!, insertIntoManagedObjectContext: context)
    }

    func getTasks() -> [ToDoTaskEntity] {
        return TaskStoreService.findTodayOrBeforeTasks(100)
    }
    
    func createTask() -> ToDoTaskEntity{
        
        var task : ToDoTaskEntity = TaskStoreService.createEntity()
        task.title = "New Task"
        task.progress = 0
        
        return task
    }

    class func createId() -> String {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        var dateTimePart = formatter.stringFromDate(NSDate())
        return "Task_\(dateTimePart)"
    }
    
    class func findTodayOrBeforeTasks(limit : Int) -> [ToDoTaskEntity] {
        
        var results : [ToDoTaskEntity] = []
        
        var variables = ["today" : NSDate()]
        if var fetchRequest = getManagedObjectModel().fetchRequestFromTemplateWithName("TodayOrBeforeFetchRequest", substitutionVariables: variables){
            fetchRequest.returnsObjectsAsFaults = false
            
            if(limit > 0){
                fetchRequest.fetchLimit = limit
            }
            
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "dueDate", ascending: true),
                NSSortDescriptor(key: "priority", ascending: false)
            ]
            
            if let fetchResults = getManagedObjectContext().executeFetchRequest(fetchRequest, error: nil) {
                results = fetchResults as [ToDoTaskEntity]
            }
        }
        
        return results
    }

}
