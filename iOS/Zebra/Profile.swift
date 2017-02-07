//
//  Profile.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation

class Profile {
    var name: String
    var email: String
    var username: String
    var password: String
    var zipCode: String
    
    init() {
        self.name = ""
        self.email = ""
        self.username = ""
        self.password = ""
        self.zipCode = ""
    }
    
    init(name: String, email: String, username: String, password: String, zipCode: String) {
        self.name = name
        self.email = email
        self.username = username
        self.password = password
        self.zipCode = zipCode
    }
}
