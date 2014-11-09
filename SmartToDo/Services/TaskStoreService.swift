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
    
    func copyEntity(id : String) -> ToDoTaskEntity? {
        
        var copiedEntity : ToDoTaskEntity?
        if let srcEntity = self.getTask(id) {
            copiedEntity = self.copyEntity(srcEntity)
        }
        
        return copiedEntity
    }
    
    func copyEntity(srcEntity : ToDoTaskEntity) -> ToDoTaskEntity {
        
        var entity = TaskStoreService.createEntity()
        entity.completionDate = srcEntity.completionDate
        entity.createdDate = NSDate()
        entity.detail = srcEntity.detail
        entity.dueDate = srcEntity.dueDate
        entity.group = srcEntity.group
        entity.id = TaskStoreService.createId()
        entity.lastModifiedDate = NSDate()
        entity.priority = srcEntity.priority
        entity.progress = srcEntity.progress
        entity.status = srcEntity.status
        entity.tag = srcEntity.tag
        entity.title = srcEntity.title
        
        return entity
    }

    func insertEntity(entity : ToDoTaskEntity) {
        
        if TaskStoreService.getManagedObjectContext().objectRegisteredForID(entity.objectID) == nil {
            TaskStoreService.getManagedObjectContext().insertObject(entity)
        }
        
        TaskStoreService.getManagedObjectContext().save(nil)
    }

    func getTasks() -> [ToDoTaskEntity] {
        return self.findTodayOrBeforeTasks(100)
    }
    
    func getTasks(date : NSDate) -> [ToDoTaskEntity] {
//        return self.findTheDayOrBeforeTasks(date, limit: 100)
        return self.findByDueDate(date, limit: 100)
    }
    
    func getTasks(fromDate : NSDate, toDate : NSDate) -> [ToDoTaskEntity] {
        return self.findByDueDate(fromDate, toDueDate: toDate, limit: 100)
    }
    
    func getTasksUnfinished(fromDate : NSDate, toDate : NSDate) -> [ToDoTaskEntity] {
        return self.findUnfinishedByDueDate(fromDate, toDueDate: toDate, limit: 100)
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
    
    func findByDueDate(dueDate : NSDate, limit : Int) -> [ToDoTaskEntity] {
        
        var results = self.findByFetchRequestTemplate("DueDateFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(dueDate), "toDueDate":DateUtility.lastEdgeOfDay(dueDate)], sortDescriptors: nil, limit: limit)
        
        return results
    }
    
    func findByDueDate(fromDueDate : NSDate, toDueDate : NSDate, limit : Int) -> [ToDoTaskEntity] {
        var results = self.findByFetchRequestTemplate("DueDateFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(fromDueDate), "toDueDate":DateUtility.lastEdgeOfDay(toDueDate)], sortDescriptors: nil, limit: limit)
        
        return results
    }
    
    func findUnfinishedByDueDate(fromDueDate : NSDate, toDueDate : NSDate, limit : Int) -> [ToDoTaskEntity] {
        var results = self.findByFetchRequestTemplate("UnfinishedFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(fromDueDate), "toDueDate":DateUtility.lastEdgeOfDay(toDueDate)], sortDescriptors: nil, limit: limit)
        
        return results
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
