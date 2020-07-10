//
//  Task.swift
//  taskapp
//
//  Created by 斉藤　剛 on 2020/07/10.
//  Copyright © 2020 tsuyoshi.saito. All rights reserved.
//

import RealmSwift

class Task: Object{
    
    @objc dynamic var id = 0
    
    @objc dynamic var title = ""
    
    @objc dynamic var contents = ""
    
    @objc dynamic var date = Date()
    
    @objc dynamic var category = ""
    
   override static func primaryKey() -> String? {
   return "id"
    
    }
    
}
