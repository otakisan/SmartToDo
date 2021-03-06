//
//  StubTaskStoreService.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/21.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import UIKit

class StubTaskStoreService: TaskStoreService {
    
    override func getTasks() -> [ToDoTaskEntity] {
        
        var tasks : [ToDoTaskEntity] = []
        for i in 1...5 {
            let task = super.createTask()
            task.title = "task\(i)"
            task.progress = Float(arc4random_uniform(9)) * 0.1
            task.id = "Task_Id_\(i)"
            tasks.append(task)
        }
        
        return tasks
    }
}
