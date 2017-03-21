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
    let regionRadius: CLLocationDistance = 1000
    
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let message = "Welcome, \(db.profile.username)"
        self.view.makeToast(message, duration: 3.0, position: .center)
        
        mapView.delegate = self
        
        self.events = db.events
        self.loadEventPins()
        

        // set initial location as ND
        let initialLocation = CLLocation(latitude: 41.7024, longitude: -86.2342)
        centerMapOnLocation(location: initialLocation)
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // Functions for map view delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? EventAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if (control as? UIButton)?.buttonType == UIButtonType.detailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: false)
            let eventAnnotation = view.annotation as! EventAnnotation
            performSegue(withIdentifier: "showEventDetailFromMap", sender: eventAnnotation.event)
        }
    }

    func loadEventPins() {
        for event in events {
            // show artwork on map
            let newEvent = EventAnnotation(event: event, title: event.title, locationName: event.locationName, discipline: event.longTimestamp, coordinate: event.position)
            
            mapView.addAnnotation(newEvent)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let event = sender as! Event
        let dest = segue.destination as! EventDetailViewController
        dest.event = event
    }

}
