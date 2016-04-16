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
    
    - returns: ManagedObjectContext
    */
    class func getManagedObjectContext() -> NSManagedObjectContext {
        
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        
        return context
    }
    
    class func getManagedObjectModel() -> NSManagedObjectModel {
        
        let appDel : AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context : NSManagedObjectModel = appDel.managedObjectModel
        
        return context
    }
    
    /**
    ToDoタスクエンティティを生成します
    
    - returns: ToDoタスクエンティティ
    */
    class func createEntity() -> ToDoTaskEntity {
        let context : NSManagedObjectContext = TaskStoreService.getManagedObjectContext()
        let ent = NSEntityDescription.entityForName("ToDoTaskEntity", inManagedObjectContext: context)
        
        return ToDoTaskEntity(entity: ent!, insertIntoManagedObjectContext: nil)
    }
    
    private func copyEntity(id : String) -> ToDoTaskEntity? {
        
        var copiedEntity : ToDoTaskEntity?
        if let srcEntity = self.getTask(id) {
            copiedEntity = self.copyEntity(srcEntity)
        }
        
        return copiedEntity
    }
    
    func copyEntity(srcEntity : ToDoTaskEntity) -> ToDoTaskEntity {
        
        let entity = TaskStoreService.createEntity()
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
        
        do {
            try TaskStoreService.getManagedObjectContext().save()
        } catch _ {
        }
    }
    
    private func deleteEntity(id : String) {
        if let entity = self.getTask(id) {
            self.deleteEntity(entity)
        }
    }
    
    func deleteEntity(entity : ToDoTaskEntity) {
        TaskStoreService.getManagedObjectContext().deleteObject(entity)
        do {
            try TaskStoreService.getManagedObjectContext().save()
        } catch _ {
        }
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
        if var results = try? TaskStoreService.getManagedObjectContext().executeFetchRequest(NSFetchRequest(entityName: "ToDoTaskEntity")) {
            for result in results as! [ToDoTaskEntity] {
                TaskStoreService.getManagedObjectContext().deleteObject(result)
            }
            
            do {
                try TaskStoreService.getManagedObjectContext().save()
            } catch _ {
            }
        }
    }
    
    func rollback() {
        TaskStoreService.getManagedObjectContext().rollback()
    }
    
    func createTask() -> ToDoTaskEntity{
        
        let task : ToDoTaskEntity = TaskStoreService.createEntity()
        task.title = "New Task"
        task.progress = 0
        
        return task
    }

    class func createId() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmssSSS"
        let dateTimePart = formatter.stringFromDate(NSDate())
        return "Task_\(dateTimePart)"
    }

    func getFetchRequestTemplate(templateName : String, variables : [String:AnyObject], sortDescriptors : [NSSortDescriptor]?, limit : Int) -> NSFetchRequest? {
        
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
    
    func countByFetchRequestTemplate(templateName : String, variables : [String:AnyObject]) -> Int {
        
        var count = 0
        
        if let fetchRequest = self.getFetchRequestTemplate(templateName, variables: variables, sortDescriptors: nil, limit: 0){
            
            count = TaskStoreService.getManagedObjectContext().countForFetchRequest(fetchRequest, error: nil)
        }
        
        return count
    }
    
    func findByFetchRequestTemplate(templateName : String, variables : [String:AnyObject], sortDescriptors : [NSSortDescriptor]?, limit : Int) -> [ToDoTaskEntity] {
        
        var results : [ToDoTaskEntity] = []
        
        if let fetchRequest = self.getFetchRequestTemplate(templateName, variables: variables, sortDescriptors: sortDescriptors, limit: limit){
            
            if let fetchResults = try? TaskStoreService.getManagedObjectContext().executeFetchRequest(fetchRequest) {
                results = fetchResults as! [ToDoTaskEntity]
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
        
        let results = self.findByFetchRequestTemplate("DueDateFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(dueDate), "toDueDate":DateUtility.lastEdgeOfDay(dueDate)], sortDescriptors: nil, limit: limit)
        
        return results
    }
    
    func findByDueDate(fromDueDate : NSDate, toDueDate : NSDate, limit : Int) -> [ToDoTaskEntity] {
        let results = self.findByFetchRequestTemplate("DueDateFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(fromDueDate), "toDueDate":DateUtility.lastEdgeOfDay(toDueDate)], sortDescriptors: nil, limit: limit)
        
        return results
    }
    
    func findUnfinishedByDueDate(fromDueDate : NSDate, toDueDate : NSDate, limit : Int) -> [ToDoTaskEntity] {
        let results = self.findByFetchRequestTemplate("UnfinishedFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(fromDueDate), "toDueDate":DateUtility.lastEdgeOfDay(toDueDate)], sortDescriptors: nil, limit: limit)
        
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
        
        let count = self.countByFetchRequestTemplate("DueDateFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(dueDate), "toDueDate":DateUtility.lastEdgeOfDay(dueDate)])
        
        return count
    }
    
    func countUnfinishedByDueDate(fromDueDate : NSDate, toDueDate : NSDate) -> Int {
        let count = self.countByFetchRequestTemplate("UnfinishedFetchRequest", variables: ["fromDueDate" : DateUtility.firstEdgeOfDay(fromDueDate), "toDueDate":DateUtility.lastEdgeOfDay(toDueDate)])
        
        return count
    }
    
    func groupByWithCount(propName : String) -> [(propValue : String, count : Int)] {
        
        var returnList : [(propValue : String, count : Int)] = []
        
        // SELECT `propName`, COUNT(propName) FROM `ToDoTaskEntity` GROUP BY `propName`
        
        var fetch = NSFetchRequest(entityName: "ToDoTaskEntity")
        
        if var entity = NSEntityDescription.entityForName("ToDoTaskEntity", inManagedObjectContext: TaskStoreService.getManagedObjectContext()) {
            
            if var groupDesc: AnyObject = entity.attributesByName[propName] {
                var keyPathExpression = NSExpression(forKeyPath: propName)
                var countExpression = NSExpression(forFunction: "count:", arguments: [keyPathExpression])
                
                var expressionDescription = NSExpressionDescription()
                expressionDescription.name = "count"
                expressionDescription.expression = countExpression
                expressionDescription.expressionResultType = NSAttributeType.Integer32AttributeType
                
                fetch.propertiesToFetch = [groupDesc, expressionDescription]
                fetch.propertiesToGroupBy = [groupDesc]
                fetch.resultType = NSFetchRequestResultType.DictionaryResultType
                
                if var results = try? TaskStoreService.getManagedObjectContext().executeFetchRequest(fetch) {
                    
                    for result in results {
                        if result[propName] != nil && result["count"] != nil {
                            let propValueData = result[propName]! as! String
                            let countData = result["count"]! as! Int
                            
                            returnList.append((propValue:propValueData, count : countData))
                        }
                    }
                }
            }
        }
        
        return returnList
        
    }
}
