//
//  MyEventsTableViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 3/20/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit

class MyEventsTableViewController: UITableViewController {

    let db = Database.sharedInstance
    var myEvents: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "My Events"
        
        refresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    func refresh() {
        self.myEvents = Array(self.db.favoriteEvents.values)
        self.tableView.reloadData()
    }
        
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return myEvents.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        let event = myEvents[indexPath.row]
        
        cell.event = event
        cell.titleLabel.text = event.title
        cell.timeLabel.text = event.shortTimestamp
        cell.descriptionLabel.text = event.description
        cell.locationLabel.text = event.locationName
        cell.setFavoriteImage()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event: Event = myEvents[indexPath.row]
        
        performSegue(withIdentifier: "showEventDetailFromMyEvents", sender: event)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let event = sender as? Event {
            let dest = segue.destination as! EventDetailViewController
            dest.event = event
        }
     }
     

}
