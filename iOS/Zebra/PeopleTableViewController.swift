//
//  PeopleTableViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 2/26/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import CoreLocation

protocol PeopleTableViewControllerDelegate{
    func didSelectPerson(person: Profile)
}

class PeopleTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var delegate: PeopleTableViewControllerDelegate! = nil
    
    var filteredPeople = [Profile]()
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    func refresh() {
        self.filteredPeople = self.db.people
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredPeople.count
        }
        return db.people.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath) as! PeopleTableViewCell
        
        let person: Profile
        
        if searchController.isActive && searchController.searchBar.text != "" {
            person = filteredPeople[indexPath.row]
        } else {
            person = db.people[indexPath.row]
        }
        
        //Set the name of the cell
        if person.showName == true {
            cell.usernameLabel.text = person.name
        } else {
            cell.usernameLabel.text = person.username
        }
        
        //Set the location of the cell
        cell.locationLabel.text = person.location
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(person.zipCode) {
            (placemarks, error) -> Void in
            if let placemark = placemarks?[0] {
                let city: String = placemark.addressDictionary?["City"] as! String
                let state: String = placemark.addressDictionary!["State"] as! String
                cell.locationLabel.text = "\(city), \(state)"
            }
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person: Profile
        if searchController.isActive && searchController.searchBar.text != "" {
            person = filteredPeople[indexPath.row]
        } else {
            person = db.people[indexPath.row]
        }
        
        delegate.didSelectPerson(person: person)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPeople.removeAll()
        filteredPeople = db.people.filter { person in
            return person.username.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}
