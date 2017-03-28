//
//  Organization.swift
//  Zebra
//
//  Created by Cory Jbara on 2/20/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class Organization {
    var name: String = ""
    var username: String = ""
    var briefBio: String = ""
    var fullBio: String = ""
    var diseases: String = ""
    var location: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init() {
        
    }
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
    
    init(snapshot: FIRDataSnapshot) {
        self.name = snapshot.childSnapshot(forPath: "name").value as! String
        self.username = snapshot.childSnapshot(forPath: "username").value as! String
        self.briefBio = snapshot.childSnapshot(forPath: "briefBio").value as! String
        self.fullBio = snapshot.childSnapshot(forPath: "fullBio").value as! String
        self.diseases = snapshot.childSnapshot(forPath: "diseases").value as! String
        self.location = snapshot.childSnapshot(forPath: "location").value as! String
        
        self.latitude = snapshot.childSnapshot(forPath: "latitude").value as! Double
        self.longitude = snapshot.childSnapshot(forPath: "longitude").value as! Double
    }
    
    
}
