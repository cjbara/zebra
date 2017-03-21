//
//  OrganizationsTableViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 3/20/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit

protocol OrganizationsTableViewControllerDelegate{
    func didSelectOrg(organization: Organization)
}

class OrganizationsTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var delegate: OrganizationsTableViewControllerDelegate! = nil
    
    let db = Database.sharedInstance
    var filteredOrganizations = [Organization]()
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
        super.viewWillAppear(animated)
        refresh()
    }
    
    func refresh() {
        self.filteredOrganizations = self.db.organizations
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
            return filteredOrganizations.count
        }
        return db.organizations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orgCell", for: indexPath) as! OrganizationTableViewCell
        
        let org: Organization
        
        if searchController.isActive && searchController.searchBar.text != "" {
            org = filteredOrganizations[indexPath.row]
        } else {
            org = db.organizations[indexPath.row]
        }
        
        //Set the name of the cell
        cell.nameLabel.text = org.name
        
        //Set the location of the cell
        cell.locationLabel.text = org.location
        
        cell.bioLabel.text = org.briefBio
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let org: Organization
        if searchController.isActive && searchController.searchBar.text != "" {
            org = filteredOrganizations[indexPath.row]
        } else {
            org = db.organizations[indexPath.row]
        }
        
        delegate.didSelectOrg(organization: org)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredOrganizations.removeAll()
        filteredOrganizations = db.organizations.filter { person in
            return person.username.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
}
