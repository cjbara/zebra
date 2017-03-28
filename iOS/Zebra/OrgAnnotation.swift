//
//  OrgAnnotation.swift
//  Zebra
//
//  Created by Cory Jbara on 3/22/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import Foundation
import MapKit

class OrgAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let bio: String
    let coordinate: CLLocationCoordinate2D
    let org: Organization
    
    init(organization: Organization) {
        self.title = organization.name
        self.bio = organization.briefBio
        self.coordinate = organization.coordinate
        self.locationName = organization.location
        self.org = organization
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
