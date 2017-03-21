//
//  EventDetailViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 3/20/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    
    let db = Database.sharedInstance
    var event = Event()

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var organizerLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var diseaseLabel: UILabel!
    @IBOutlet var purposeLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = event.title
        organizerLabel.text = event.organizer
        dateLabel.text = event.longTimestamp
        locationLabel.text = event.locationName
        diseaseLabel.text = event.disease
        purposeLabel.text = event.description
        
        setFavoriteImage()
        
    }

    func setFavoriteImage() {
        if db.favoriteEvents[event.id] == nil {
            favoriteButton.setImage(#imageLiteral(resourceName: "empty-star"), for: UIControlState.normal)
        } else {
            favoriteButton.setImage(#imageLiteral(resourceName: "star"), for: UIControlState.normal)
        }
    }
    
    @IBAction func addFavorite(_ sender: UIButton) {
        db.saveEventAsFavorite(event: self.event)
        setFavoriteImage()
    }
}
