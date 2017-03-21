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
    
    func setLocation() {
        location = zipCode
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipCode) {
            (placemarks, error) -> Void in
            print("Got address for \(self.username)")
            if let placemark = placemarks?[0] {
                let city: String = placemark.addressDictionary?["City"] as! String
                let state: String = placemark.addressDictionary!["State"] as! String
                self.location = "\(city), \(state)"
            } else {
                self.location = self.zipCode
            }
        }
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
        
        setLocation()
    }
    
    func reset() {
        email = ""
        username = ""
        name = ""
        zipCode = ""
        aboutMe = ""
        showName = false
        privacy = false
    }
    
    func updateUserData(name: String, zipCode: String, about: String, privacy: Bool, showName: Bool) {
        self.name = name
        self.zipCode = zipCode
        self.aboutMe = about
        self.showName = showName
        self.privacy = privacy
        
        setLocation()
    }
    
}
