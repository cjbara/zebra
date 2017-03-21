//
//  EventTableViewCell.swift
//  Zebra
//
//  Created by Cory Jbara on 3/5/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    let db = Database.sharedInstance
    var event = Event()

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var locationLabel: UILabel!
    
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
