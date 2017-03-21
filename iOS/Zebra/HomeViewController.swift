//
//  HomeViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 2/19/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import Toast_Swift

class HomeViewController: UIViewController, PeopleTableViewControllerDelegate, EventsTableViewControllerDelegate, OrganizationsTableViewControllerDelegate {
    
    var db: Database = Database.sharedInstance
    
    @IBOutlet var container: UIView!
    @IBOutlet var tabs: UISegmentedControl!
    @IBAction func newTabSelected(_ sender: Any) {
        if tabs.selectedSegmentIndex == 0 {
            container.addSubview(eventsViewController.view)
        } else if tabs.selectedSegmentIndex == 1 {
            container.addSubview(organizationsViewController.view)
        } else {
            container.addSubview(peopleViewController.view)
        }
    }
    
    private lazy var peopleViewController: PeopleTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "PeopleTableViewController") as! PeopleTableViewController
        
        return viewController
    }()
    
    private lazy var organizationsViewController: OrganizationsTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "OrganizationsTableViewController") as! OrganizationsTableViewController
        
        return viewController
    }()
    
    private lazy var eventsViewController: EventsTableViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "EventsTableViewController") as! EventsTableViewController
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peopleViewController.delegate = self
        eventsViewController.delegate = self
        organizationsViewController.delegate = self
        
        //Make initial subview the events
        container.addSubview(eventsViewController.view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        peopleViewController.refresh()
        eventsViewController.refresh()
        organizationsViewController.refresh()
    }
    
    func didSelectPerson(person: Profile) {
        performSegue(withIdentifier: "personDetail", sender: person)
    }
    
    func didSelectEvent(event: Event) {
        performSegue(withIdentifier: "eventDetail", sender: event)
    }
    
    func didSelectOrg(organization: Organization) {
        performSegue(withIdentifier: "orgDetail", sender: organization)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let person = sender as? Profile {
            let dest = segue.destination as! PersonViewController
            dest.person = person
        } else if let event = sender as? Event {
            let dest = segue.destination as! EventDetailViewController
            dest.event = event
        } else if let org = sender as? Organization {
            let dest = segue.destination as! OrganizationDetailViewController
            dest.organization = org
        }
        
    }
 

}
