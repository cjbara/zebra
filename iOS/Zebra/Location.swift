//
//  Location.swift
//  Zebra
//
//  Created by Cory Jbara on 2/20/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import CoreLocation

class MyLocation {
    var latitude: Double
    var longitude: Double
    var name: String = ""
    var zipCode: String = ""
    
    init(mark: CLPlacemark) {
        self.name = mark.name!
        self.zipCode = mark.postalCode!
        self.latitude = mark.location!.coordinate.latitude
        self.longitude = mark.location!.coordinate.longitude
    }
}
