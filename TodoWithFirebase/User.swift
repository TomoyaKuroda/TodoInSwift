//
//  User.swift
//  TodoWithFirebase
//
//  Created by user user on 2019/08/02.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit

class User {
    var uid: String
    var email: String
    var password: String
    init(uid: String, email: String, password: String) {
        self.uid = uid
        self.email = email
        self.password = password
    }
}
