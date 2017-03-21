//
//  EventsTableViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 3/5/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit

protocol EventsTableViewControllerDelegate {
    func didSelectEvent(event: Event)
}

class EventsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var delegate: EventsTableViewControllerDelegate! = nil
    
    var filteredEvents = [Event]()
    let db = Database.sharedInstance
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        refresh()
    }

    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    func refresh() {
        self.filteredEvents = self.db.events
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredEvents.count
        }
        return db.events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        
        let event = db.events[indexPath.row]
        
        cell.event = event
        cell.titleLabel.text = event.title
        cell.timeLabel.text = event.shortTimestamp
        cell.descriptionLabel.text = event.description
        cell.locationLabel.text = event.locationName
        cell.setFavoriteImage()
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event: Event
        if searchController.isActive && searchController.searchBar.text != "" {
            event = filteredEvents[indexPath.row]
        } else {
            event = db.events[indexPath.row]
        }
        
        delegate.didSelectEvent(event: event)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredEvents.removeAll()
        filteredEvents = db.events.filter { event in
            return event.title.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
