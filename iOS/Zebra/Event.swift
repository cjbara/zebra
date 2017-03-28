//
//  Event.swift
//  Zebra
//
//  Created by Cory Jbara on 3/5/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class Event {
    var id: String
    var date: Date
    var description: String
    var disease: String
    var title: String
    var organizer: String
    
    var favorite: Bool = false
    
    var location: CLLocationCoordinate2D
    var locationName: String
    
    var longTimestamp: String {
        let df = DateFormatter()
        df.dateFormat = "EEEE, M/d"
        let df2 = DateFormatter()
        df2.dateFormat = "h:mm a"
        
        return df.string(from: date) + "\nat " + df2.string(from: date)
    }
    
    var shortTimestamp: String {
        let df = DateFormatter()
        df.dateFormat = "M/d"
        let df2 = DateFormatter()
        df2.dateFormat = "h:mm a"
        
        return df.string(from: date) + " at " + df2.string(from: date)

    }
    
    init(snapshot: FIRDataSnapshot) {
        self.id = snapshot.key
        self.date = Date(timeIntervalSince1970: snapshot.childSnapshot(forPath: "date").value as! Double)
        self.description = snapshot.childSnapshot(forPath: "description").value as! String
        self.title = snapshot.childSnapshot(forPath: "title").value as! String
        self.organizer = snapshot.childSnapshot(forPath: "organization").value as! String
        self.disease = snapshot.childSnapshot(forPath: "disease").value as! String
        
        let latitude = snapshot.childSnapshot(forPath: "latitude").value as! Double
        let longitude = snapshot.childSnapshot(forPath: "longitude").value as! Double
        
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.locationName = snapshot.childSnapshot(forPath: "locationName").value as! String

    }
    
    init() {
        id = ""
        date = Date()
        description = "To learn about stuff"
        disease = "Disease"
        title = "Event Name"
        organizer = "Me"
        location = CLLocationCoordinate2D()
        locationName = "Hesburgh Library"
    }
    
}
