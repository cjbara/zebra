//
//  EventAnnotation.swift
//  Zebra
//
//  Created by Cory Jbara on 3/1/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let event: Event
    
    init(event: Event, title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.event = event
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
