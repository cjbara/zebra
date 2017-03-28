//
//  PersonAnnotation.swift
//  Zebra
//
//  Created by Cory Jbara on 3/22/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import MapKit

class PersonAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    let person: Profile
    
    init(person: Profile) {
        self.title = person.name
        self.locationName = person.location
        self.coordinate = person.coordinates
        self.person = person
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
