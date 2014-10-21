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
        return []
    }
    
    func createTask() -> ToDoTaskEntity{
        
        var task : ToDoTaskEntity = TaskStoreService.createEntity()
        task.title = "New Task"
        task.progress = 0
        
        return task
    }
   
}
