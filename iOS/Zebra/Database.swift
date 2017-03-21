//
//  Database.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class Database {
    
    var ref: FIRDatabaseReference!
    private var initialized = false
    static let sharedInstance = Database()
    
    var profile = Profile()
    var people = [Profile]()
    var events = [Event]()
    var organizations = [Organization]()
    var favoriteEvents = [String:Event]()
    
    func initialize() {
        if initialized == true{
            return
        }
        ref = FIRDatabase.database().reference()
        initialized = true
    }
    
    func checkAuth(callback: @escaping ((Bool) -> Void)){
        if FIRAuth.auth()?.currentUser != nil {
            self.ref.child("userId").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                let username = snapshot.value as! String
                self.ref.child("users").child(username).observeSingleEvent(of: .value, with: { (userData) in
                    
                    //create profile
                    self.profile = Profile(userData: userData)
                    self.getPeople()
                    self.getEvents()
                    self.getOrganizations()
                    callback(true)
                })
            })
        } else {
            callback(false)
       }
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
                        self.getPeople()
                        self.getEvents()
                        self.getOrganizations()
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
    
    func setUserLocation(zipCode: String, callback: @escaping (String, CLLocationCoordinate2D) -> ()) {
        var location = zipCode
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipCode) {
            (placemarks, error) -> Void in
            if let placemark = placemarks?[0] {
                
                let place = placemark.location?.coordinate
                
                let city: String = placemark.addressDictionary?["City"] as! String
                let state: String = placemark.addressDictionary!["State"] as! String
                location = "\(city), \(state)"
                callback(location, place!)
            } else {
                callback(zipCode, CLLocationCoordinate2D(latitude: 41.7056, longitude: -86.2353))
            }
        }
    }
    
    func updateUserData(name: String, zipCode: String, about: String, privacy: Bool, showName: Bool, callback: ((Bool) -> Void)?) {
        
        setUserLocation(zipCode: zipCode) { (location, placemark) in
            let uid = FIRAuth.auth()?.currentUser?.uid
            let userData = ["uid": uid!, "email": self.profile.email, "username": self.profile.username, "name": name, "zipCode": zipCode, "about": about, "showName": showName, "privacy": privacy, "location": location, "latitude": placemark.latitude, "longitude": placemark.longitude] as [String : Any]
            
            self.ref.child("users").child(self.profile.username).setValue(userData)
            
            self.profile.updateUserData(name: name, zipCode: zipCode, about: about, privacy: privacy, showName: showName, location: location, latitude: placemark.latitude, longitude: placemark.longitude)
            
            if callback != nil {
                callback!(true)
            }
        }
    }
    
    func createEvent(title: String, mylocation: MyLocation, date: NSDate, disease: String, organizer: String, description: String) {
        
        let eventData: [String: Any] = [
            "title": title,
            "latitude": mylocation.latitude,
            "longitude": mylocation.longitude,
            "date": date.timeIntervalSince1970,
            "disease": disease,
            "organization": organizer,
            "description": description,
            "locationName": mylocation.name
        ]
        
        let newref = ref.child("events").childByAutoId()
        newref.setValue(eventData)
        
        //Save this to the list of your events after you create it
        ref.child("users").child(profile.username).child("events").child(newref.key).setValue(newref.key)
    }
    
    func getPeople() {
        ref.child("users").observe(.value, with: { (snapshot) in
            self.people.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let newPerson = Profile(userData: child)
                self.people.append(newPerson)
            }
        })
    }
    
    func getEvents() {
        ref.child("events").queryOrdered(byChild: "date").observe(.value, with: { (snapshot) in
            self.events.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let newEvent = Event(snapshot: child)
                
                if self.favoriteEvents[newEvent.id] != nil {
                    newEvent.favorite = true
                }
                self.events.append(newEvent)
            }
        })
    }
    
    func getOrganizations() {
        ref.child("organizations").observe(.value, with: { (snapshot) in
            self.organizations.removeAll()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let newOrg = Organization(snapshot: child)
                self.organizations.append(newOrg)
            }
        })
    }
    
    func getPerson(withUsername username: String, callback: ((Profile) -> Void)?) {
        ref.child("users").child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            let person = Profile(userData: snapshot)
            callback!(person)
        })
    }
    
    func saveEventAsFavorite(event: Event) {
        if self.favoriteEvents[event.id] == nil {
            self.favoriteEvents[event.id] = event
            self.ref.child("users").child(self.profile.username).child("events").child(event.id).setValue(event.id)
        } else {
            self.favoriteEvents.removeValue(forKey: event.id)
            self.ref.child("users").child(self.profile.username).child("events").child(event.id).setValue(nil)
        }
    }
    
}
