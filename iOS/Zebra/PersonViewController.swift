//
//  PersonViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 2/26/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {

    @IBOutlet var personName: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var diseaseLabel: UILabel!
    @IBOutlet var bioLabel: UITextView!
    @IBOutlet var emailLabel: UIButton!
    
    var person = Profile()
    
    let db = Database.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personName.text = person.name
        locationLabel.text = person.location
        diseaseLabel.text = person.disease
        bioLabel.text = person.aboutMe
        
        emailLabel.setImage(#imageLiteral(resourceName: "mail"), for: .normal)
        
    }
}
