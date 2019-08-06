//
//  Todo.swift
//  TodoWithFirebase
//
//  Created by Yang Su on 2019-08-06.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit

class Todo{
    var isChecked: Bool
    var todoName:String
    init(isChecked :Bool, todoName :String) {
        self.isChecked=isChecked
        self.todoName=todoName
    }
}
