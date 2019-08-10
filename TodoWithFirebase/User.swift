//
//  User.swift
//  TodoWithFirebase
//
//  Created by Tomoya Kuroda on 2019/08/02.
//  Copyright © 2019 Group8. All rights reserved.
//

import UIKit

class User {
    var uid: String
    var email: String
    var password: String
    // Initialize
    init(uid: String, email: String, password: String) {
        self.uid = uid
        self.email = email
        self.password = password
    }
}
