//
//  OrganizationDetailViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 3/20/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit

class OrganizationDetailViewController: UIViewController {
    
    @IBOutlet var orgName: UILabel!
    @IBOutlet var orgLocation: UILabel!
    @IBOutlet var diseaseLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    
    var organization = Organization()

    let db = Database.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orgName.text = organization.name
        orgLocation.text = organization.location
        diseaseLabel.text = organization.diseases
        bioLabel.text = organization.fullBio
        
    }

}
