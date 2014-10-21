//
//  ToDoTaskEntity.swift
//  SmartToDo
//
//  Created by Takashi Ikeda on 2014/10/21.
//  Copyright (c) 2014年 ti. All rights reserved.
//

import Foundation
import CoreData

@objc(ToDoTaskEntity)
class ToDoTaskEntity: NSManagedObject {

    @NSManaged var completionDate: NSDate
    @NSManaged var createdDate: NSDate
    @NSManaged var detail: String
    @NSManaged var dueDate: NSDate
    @NSManaged var group: String
    @NSManaged var id: String
    @NSManaged var lastModifiedDate: NSDate
    @NSManaged var priority: NSNumber
    @NSManaged var progress: NSNumber
    @NSManaged var status: String
    @NSManaged var tag: String
    @NSManaged var title: String

}
