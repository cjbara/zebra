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
    var isPublic: Bool
    var title: String
    var organizer: String
    
    var favorite: Bool = false
    
    var locationName = "Hesburgh Library"
    var position: CLLocationCoordinate2D {
        //Gets random location within .01 lat and long of the Hesburg Library
        let lat = 41.7024 + Double((Double(arc4random_uniform(10)) - 5) / 1000.0)
        let lon = -86.2342 + Double((Double(arc4random_uniform(10)) - 5) / 1000.0)
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    var longTimestamp: String {
        let df = DateFormatter()
        df.dateFormat = "EEEE, M d"
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
        self.organizer = snapshot.childSnapshot(forPath: "organizerUsername").value as! String
        self.isPublic = snapshot.childSnapshot(forPath: "isPublic").value as! Bool
        self.disease = snapshot.childSnapshot(forPath: "disease").value as! String
    }
    
    init() {
        id = ""
        date = Date()
        description = "To learn about stuff"
        disease = "Disease"
        isPublic = true
        title = "Event Name"
        organizer = "Me"
    }
    
//    let locationName = "Hesburgh Library Notre Dame"
//    
//    let geocoder = CLGeocoder()
//    geocoder.geocodeAddressString(locationName) { (placemarks, error) in
//    print(placemarks)
//    if let placemark = placemarks?[0] {
//    let locationLatLon: CLLocation = placemark.location!
//    print(locationLatLon)
//    } else {
//    self.view.makeToast("Could not find location: locationName")
//    }
//    }
    
}
