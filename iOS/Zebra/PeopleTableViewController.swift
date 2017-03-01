//
//  PeopleTableViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 2/26/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var filteredPeople = [Profile]()
    let db = Database.sharedInstance
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        db.getAllPeople {
            self.filteredPeople = self.db.people
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        
        cell.usernameLabel.text = person.username
        cell.locationLabel.text = person.location
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let vc = segue.destination as! PersonViewController
        let cell = sender as! PeopleTableViewCell
        let indexPath = self.tableView.indexPath(for: cell)!
        
        if searchController.isActive && searchController.searchBar.text != "" {
            vc.person = filteredPeople[indexPath.row]
        } else {
            vc.person = db.people[indexPath.row]
        }
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
