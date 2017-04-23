//
//  ToDo.swift
//  todo-app-example
//
//  Created by Raphael Araújo on 4/22/17.
//  Copyright © 2017 Raphael Araujo. All rights reserved.
//

import UIKit
import RealmSwift

class ToDo: Object {
    dynamic var toDoId: String = NSUUID().uuidString
    dynamic var name = ""
    dynamic var text = ""
    dynamic var lastUpdated = Date()
    dynamic var priority = 0
    
    func priorityStr() -> String {
        let priorityValues = ["low", "medium", "high"]
        return priorityValues[self.priority]
    }
    
    override class func primaryKey() -> String? {
        return "toDoId"
    }

    func lastUpdatedStr() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        return dateFormatter.string(from: self.lastUpdated)
    }
    
    class func list() -> [ToDo] {
        var toDosArray = [ToDo]()
        let realm = try! Realm()
        let toDos = realm.objects(ToDo.self)
        if(toDos.count > 0) {
            toDosArray.append(contentsOf: toDos)
        }
        return toDosArray
    }
    func freeCopy() -> ToDo {
        let toDo = ToDo()
        toDo.name = self.name
        toDo.toDoId = self.toDoId
        toDo.lastUpdated = self.lastUpdated
        toDo.priority = self.priority
        toDo.text = self.text
        return toDo
    }
    
    func save() {
        let realm = try! Realm()
        try! realm.write {
            self.lastUpdated = Date()
            realm.add(self, update: true)
        }
    }
    
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
}
