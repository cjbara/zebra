//
//  Profile.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import Firebase

class Profile {
    var email: String
    var username: String
    
    init() {
        self.email = ""
        self.username = ""
    }
    
    init(email: String, username: String) {
        self.email = email
        self.username = username
    }
    
    init(userData: FIRDataSnapshot) {
        email = userData.childSnapshot(forPath: "email").value as! String
        username = userData.childSnapshot(forPath: "username").value as! String
    }
    
    func reset() {
        email = ""
        username = ""
    }
}
