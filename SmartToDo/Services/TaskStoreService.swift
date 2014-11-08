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
        
        return ToDoTaskEntity(entity: ent!, insertIntoManagedObjectContext: nil)
    }

    func getTasks() -> [ToDoTaskEntity] {
        return self.findTodayOrBeforeTasks(100)
    }
    
    func getTasks(date : NSDate) -> [ToDoTaskEntity] {
        return self.findTheDayOrBeforeTasks(date, limit: 100)
    }
    
    func getTask(id : String) -> ToDoTaskEntity? {
        return self.findById(id)
    }

    func clearAllTasks() {
        if var results = TaskStoreService.getManagedObjectContext().executeFetchRequest(NSFetchRequest(entityName: "ToDoTaskEntity"), error: nil) {
            for result in results as [ToDoTaskEntity] {
                TaskStoreService.getManagedObjectContext().deleteObject(result)
            }
            
            TaskStoreService.getManagedObjectContext().save(nil)
        }
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
    
    func findByFetchRequestTemplate(templateName : String, variables : [NSObject:AnyObject], sortDescriptors : [AnyObject]?, limit : Int) -> [ToDoTaskEntity] {
        
        var results : [ToDoTaskEntity] = []
        
        if var fetchRequest = TaskStoreService.getManagedObjectModel().fetchRequestFromTemplateWithName(templateName, substitutionVariables: variables){
            fetchRequest.returnsObjectsAsFaults = false
            
            if(limit > 0){
                fetchRequest.fetchLimit = limit
            }
            
            fetchRequest.sortDescriptors = sortDescriptors
            if let fetchResults = TaskStoreService.getManagedObjectContext().executeFetchRequest(fetchRequest, error: nil) {
                results = fetchResults as [ToDoTaskEntity]
            }
        }
        
        return results
    }

    func findById(id : String) -> ToDoTaskEntity? {
        
        var entity : ToDoTaskEntity? = nil
        var results = self.findByFetchRequestTemplate("IdFetchRequest", variables: ["id" : id], sortDescriptors: nil, limit: 0)
        if results.count > 0{
            entity = results[0]
        }
        
        return entity
    }
    
    func findTodayOrBeforeTasks(limit : Int) -> [ToDoTaskEntity] {
        
        return self.findByFetchRequestTemplate(
            "TodayOrBeforeFetchRequest",
            variables: ["today" : NSDate()],
            sortDescriptors: [
                NSSortDescriptor(key: "dueDate", ascending: true),
                NSSortDescriptor(key: "priority", ascending: false)
                ],
            limit: limit)
    }
    
    func findTheDayOrBeforeTasks(date : NSDate, limit : Int) -> [ToDoTaskEntity] {
        
        return self.findByFetchRequestTemplate(
            "TodayOrBeforeFetchRequest",
            variables: ["today" : date],
            sortDescriptors: [
                NSSortDescriptor(key: "dueDate", ascending: true),
                NSSortDescriptor(key: "priority", ascending: false)
            ],
            limit: limit)
    }

}
