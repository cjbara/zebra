//
//  Database.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import Firebase

class Database {
    
    var ref: FIRDatabaseReference!
    private var initialized = false
    static let sharedInstance = Database()
    
    var profile = Profile()
    var diseases = [String: String]()
    var diseasesLoaded = false
    
    func initialize() {
        if initialized == true{
            return
        }
        ref = FIRDatabase.database().reference()
        initialized = true
    }
    
    func createUser(email: String, password: String, username: String, callback: @escaping (Bool) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                callback(false)
            } else {
                //Insert data into firebase
                let uid = FIRAuth.auth()?.currentUser?.uid
                let userData = ["uid": uid!, "email": email, "username": username] as [String : String]
                
                self.ref.child("users/\(username)").setValue(userData)
                self.profile = Profile(email: email, username: username)
                
                self.ref.child("userId/\(uid!)").setValue(username)

                callback(true)
            }
        }
    }
    
    func checkUsername(username: String, callback: @escaping (Bool) -> Void) {
        ref.child("users").observeSingleEvent(of: .value) {
            (snapshot:FIRDataSnapshot) in
            let userExists: Bool = snapshot.hasChild(username)
            callback(userExists)
        }
    }
    
    func signIn(email: String, password: String, callback: @escaping (Bool) -> Void ) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if (error == nil) {
                self.ref.child("userId").child((user?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    let username = snapshot.value as! String
                    self.ref.child("users").child(username).observeSingleEvent(of: .value, with: { (userData) in
                        
                        //create profile
                        self.profile = Profile(userData: userData)
                        callback(true)
                    })
                })
            } else {
                callback(false)
            }
        }
    }
    
    func signOut(callback: @escaping (Bool) -> Void ) {
        do {
            try FIRAuth.auth()?.signOut()
            profile.reset()
            callback(true)
        } catch {
            callback(false)
        }
    }
    
    func getDiseases() {
        ref.child("diseases").observeSingleEvent(of: .value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let child = enumerator.nextObject() as? FIRDataSnapshot {
                self.diseases[child.key] = (child.value as! String)
            }
            self.diseasesLoaded = true
            print(self.diseases)
        })
    }
    
    func updateUserData(name: String, zipCode: String, about: String, account: String, privacy: String, callback: ((Bool) -> Void)?) {
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        let userData = ["uid": uid!, "email": profile.email, "username": profile.username, "name": name, "zipCode": zipCode, "about": about, "account": account, "privacy": privacy] as [String : String]
        
        ref.child("users").child(profile.username).setValue(userData)
        
        profile.updateUserData(name: name, zipCode: zipCode, about: about, account: account, privacy: privacy)
        
        if callback != nil {
            callback!(true)
        }
    }
    
}
