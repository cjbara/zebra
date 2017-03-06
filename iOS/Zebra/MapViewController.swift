//
//  MapViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 3/1/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    let db = Database.sharedInstance
    
    @IBOutlet var mapView: MKMapView!
    let regionRadius: CLLocationDistance = 1000
    
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        db.getListOfEvents { (newEvents) in
            self.events = newEvents
            
            self.loadEventPins()
        }
        
        

        // set initial location in Honolulu
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
        //I don't know how to convert this if condition to swift 1.2 but you can remove it since you don't have any other button in the annotation view
        if (control as? UIButton)?.buttonType == UIButtonType.detailDisclosure {
            mapView.deselectAnnotation(view.annotation, animated: false)
            performSegue(withIdentifier: "showEventDetailFromMap", sender: self)
        }
    }

    func loadEventPins() {
        for event in events {
            // show artwork on map
            let newEvent = EventAnnotation(title: event.title,
                                          locationName: event.locationName,
                                          discipline: event.longTimestamp,
                                          coordinate: event.position)
            
            mapView.addAnnotation(newEvent)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
