//
//  Profile.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class Profile {
    var email: String
    var username: String
    var name: String = ""
    var zipCode: String = ""
    var aboutMe: String = ""
    var showName: Bool = false
    var privacy: Bool = false
    var location: String = ""
    var disease: String = "Cystic Fibrosis"

    var latitude: Double = 0
    var longitude: Double = 0
    
    var coordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init() {
        self.email = ""
        self.username = ""
    }
    
    init(email: String, username: String) {
        self.email = email
        self.username = username
    }
    
    init(userData: FIRDataSnapshot) {
        self.email = userData.childSnapshot(forPath: "email").value as! String
        self.username = userData.childSnapshot(forPath: "username").value as! String
        self.name = userData.childSnapshot(forPath: "name").value as! String
        self.zipCode = userData.childSnapshot(forPath: "zipCode").value as! String
        self.aboutMe = userData.childSnapshot(forPath: "about").value as! String
        self.showName = userData.childSnapshot(forPath: "showName").value as! Bool
        self.privacy = userData.childSnapshot(forPath: "privacy").value as! Bool
        
        self.location = userData.childSnapshot(forPath: "location").value as! String
        self.latitude = userData.childSnapshot(forPath: "latitude").value as! Double
        self.longitude = userData.childSnapshot(forPath: "longitude").value as! Double
    }
    
    func reset() {
        email = ""
        username = ""
        name = ""
        zipCode = ""
        aboutMe = ""
        showName = false
        privacy = false
        
        location = ""
        latitude = 0
        longitude = 0
    }
    
    func updateUserData(name: String, zipCode: String, about: String, privacy: Bool, showName: Bool, location: String, latitude: Double, longitude: Double) {
        self.name = name
        self.zipCode = zipCode
        self.aboutMe = about
        self.showName = showName
        self.privacy = privacy
        
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
