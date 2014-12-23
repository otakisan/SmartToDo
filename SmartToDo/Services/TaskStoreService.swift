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
    
    func deleteEntity(id : String) {
        if var entity = self.getTask(id) {
            self.deleteEntity(entity)
        }
    }
    
    func deleteEntity(entity : ToDoTaskEntity) {
        TaskStoreService.getManagedObjectContext().deleteObject(entity)
        TaskStoreService.getManagedObjectContext().save(nil)
    }

    func getTasks() -> [ToDoTaskEntity] {
        return self.findTodayOrBeforeTasks(100)
    }
    
    func getTasks(date : NSDate) -> [ToDoTaskEntity] {
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
    
    func getTaskCount(dueDate : NSDate) -> Int {
        return self.countByDueDate(dueDate)
    }

    func clearAllTasks() {
        if var results = TaskStoreService.getManagedObjectContext().executeFetchRequest(NSFetchRequest(entityName: "ToDoTaskEntity"), error: nil) {
            for result in results as [ToDoTaskEntity] {
                TaskStoreService.getManagedObjectContext().deleteObject(result)
            }
            
            TaskStoreService.getManagedObjectContext().save(nil)
        }
    }
    
    func rollback() {
        TaskStoreService.getManagedObjectContext().rollback()
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

    func getFetchRequestTemplate(templateName : String, variables : [NSObject:AnyObject], sortDescriptors : [AnyObject]?, limit : Int) -> NSFetchRequest? {
        
        var request : NSFetchRequest?
        
        if var fetchRequest = TaskStoreService.getManagedObjectModel().fetchRequestFromTemplateWithName(templateName, substitutionVariables: variables){
            fetchRequest.returnsObjectsAsFaults = false
            
            if(limit > 0){
                fetchRequest.fetchLimit = limit
            }
            
            fetchRequest.sortDescriptors = sortDescriptors
            
            request = fetchRequest
        }
        
        return request
    }
    
    func countByFetchRequestTemplate(templateName : String, variables : [NSObject:AnyObject]) -> Int {
        
        var count = 0
        
        if var fetchRequest = self.getFetchRequestTemplate(templateName, variables: variables, sortDescriptors: nil, limit: 0){
            
            count = TaskStoreService.getManagedObjectContext().countForFetchRequest(fetchRequest, error: nil)
        }
        
        return count
    }
    
    func findByFetchRequestTemplate(templateName : String, variables : [NSObject:AnyObject], sortDescriptors : [AnyObject]?, limit : Int) -> [ToDoTaskEntity] {
        
        var results : [ToDoTaskEntity] = []
        
        if var fetchRequest = self.getFetchRequestTemplate(templateName, variables: variables, sortDescriptors: sortDescriptors, limit: limit){
            
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
    
    func countByDueDate(dueDate : NSDate) -> Int {
        
        var count = self.countByFetchRequestTemplate("DueDateFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(dueDate), "toDueDate":DateUtility.lastEdgeOfDay(dueDate)])
        
        return count
    }
    
    func countUnfinishedByDueDate(fromDueDate : NSDate, toDueDate : NSDate) -> Int {
        var count = self.countByFetchRequestTemplate("UnfinishedFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(fromDueDate), "toDueDate":DateUtility.lastEdgeOfDay(toDueDate)])
        
        return count
    }

    func getGroups() -> [(group : String, count : Int)] {
        
        var returnList : [(group : String, count : Int)] = []
        
        // SELECT `group`, COUNT(group) FROM `ToDoTaskEntity` GROUP BY `group`
        
        var fetch = NSFetchRequest(entityName: "ToDoTaskEntity")
        
        if var entity = NSEntityDescription.entityForName("ToDoTaskEntity", inManagedObjectContext: TaskStoreService.getManagedObjectContext()) {
            
            if var groupDesc: AnyObject = entity.attributesByName["group"] {
                var keyPathExpression = NSExpression(forKeyPath: "group")
                var countExpression = NSExpression(forFunction: "count:", arguments: [keyPathExpression])
                
                var expressionDescription = NSExpressionDescription()
                expressionDescription.name = "count"
                expressionDescription.expression = countExpression
                expressionDescription.expressionResultType = NSAttributeType.Integer32AttributeType
                
                fetch.propertiesToFetch = [groupDesc, expressionDescription]
                fetch.propertiesToGroupBy = [groupDesc]
                fetch.resultType = NSFetchRequestResultType.DictionaryResultType
                
                if var results = TaskStoreService.getManagedObjectContext().executeFetchRequest(fetch, error: nil) {
                    
                    for result in results {
                        if result["group"] != nil && result["count"] != nil {
                            let groupData = result["group"]! as String
                            let countData = result["count"]! as Int
                            
                            returnList.append((group:groupData, count : countData))
                        }
                    }
                }
            }
        }
        
        return returnList
    }
}
