//
//  MapViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 3/1/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import MapKit
import Toast_Swift

class MapViewController: UIViewController, MKMapViewDelegate {

    let db = Database.sharedInstance
    
    @IBOutlet var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 10000
    @IBOutlet var eventsBox: UISwitch!
    @IBOutlet var orgsBox: UISwitch!
    @IBOutlet var peopleBox: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let message = "Welcome, \(db.profile.username)"
        self.view.makeToast(message, duration: 3.0, position: .center)
        
        mapView.delegate = self
        
        refresh()
        
        // set initial location as ND
        let initialLocation = db.profile.coordinates
        centerMapOnLocation(location: initialLocation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    @IBAction func orgsClicked(_ sender: UISwitch) {
        refresh()
    }
    
    @IBAction func eventsClicked(_ sender: UISwitch) {
        refresh()
    }
    
    @IBAction func peopleClicked(_ sender: UISwitch) {
        refresh()
    }
    
    func refresh() {
        self.loadPins()
    }

    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Functions for map view delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? EventAnnotation {
            var view: MKPinAnnotationView
            
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "eventPin")
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            view.pinTintColor = UIColor(colorLiteralRed: 111/255, green: 63/255, blue: 224/255, alpha: 1)
            
            return view
            
        } else if let annotation = annotation as? PersonAnnotation {
            var view: MKPinAnnotationView
            
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "personPin")
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            view.pinTintColor = UIColor(colorLiteralRed: 233/255, green: 151/255, blue: 0/255, alpha: 1)
            
            return view
        } else if let annotation = annotation as? OrgAnnotation {
            var view: MKPinAnnotationView
            
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "personPin")
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            view.pinTintColor = UIColor(colorLiteralRed: 91/255, green: 166/255, blue: 244/255, alpha: 1)
            
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control as? UIButton)?.buttonType == UIButtonType.detailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: false)
            if let eventAnnotation = view.annotation as? EventAnnotation {
                performSegue(withIdentifier: "showEventDetailFromMap", sender: eventAnnotation.event)
            } else if let orgAnnotation = view.annotation as? OrgAnnotation {
                performSegue(withIdentifier: "showOrgDetailFromMap", sender: orgAnnotation.org)
            } else if let personAnnotation = view.annotation as? PersonAnnotation {
                performSegue(withIdentifier: "showPersonDetailFromMap", sender: personAnnotation.person)
            }
        }
    }

    func loadPins() {
        for anno : MKAnnotation in mapView.annotations {
            mapView.removeAnnotation(anno)
        }
        
        if eventsBox.isOn {
            for event in db.events {
                // show artwork on map
                let newEvent = EventAnnotation(event: event)
                mapView.addAnnotation(newEvent)
            }
        }
        
        if peopleBox.isOn {
            for person in db.people {
                let newPerson = PersonAnnotation(person: person)
                mapView.addAnnotation(newPerson)
            }
        }
        
        if orgsBox.isOn {
            for org in db.organizations {
                let newOrg = OrgAnnotation(organization: org)
                mapView.addAnnotation(newOrg)
            }
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let event = sender as? Event {
            let dest = segue.destination as! EventDetailViewController
            dest.event = event
        } else if let person = sender as? Profile {
            let dest = segue.destination as! PersonViewController
            dest.person = person
        } else if let org = sender as? Organization {
            let dest = segue.destination as! OrganizationDetailViewController
            dest.organization = org
        }
        
    }

}
