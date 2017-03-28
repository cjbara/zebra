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
    
    init(event: Event) {
        self.event = event
        self.title = event.title
        self.locationName = event.locationName
        self.discipline = event.longTimestamp
        self.coordinate = event.location
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
