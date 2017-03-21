//
//  CreateEventViewController.swift
//  Zebra
//
//  Created by Madelyn Nelson on 2/20/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import CoreLocation
import LocationPicker

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var diseaseTextView: UITextView!
    @IBOutlet weak var sponsorTextView: UITextView!
    @IBOutlet weak var purposeTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    var db: Database = Database.sharedInstance
    
    var date: Date? = nil
    var myLocation: MyLocation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timeLabel.text = ""
        self.locationLabel.text = ""
        
        self.styleSubmitButton()
    }
    
    func clearTextFields() {
        self.titleTextView.text = ""
        self.diseaseTextView.text = ""
        self.sponsorTextView.text = ""
        self.purposeTextView.text = ""
        
        self.timeLabel.text = ""
        self.locationLabel.text = ""


    }
    
    func styleSubmitButton() {
        self.submitButton.backgroundColor = UIColor.green
        self.submitButton.layer.cornerRadius = 5
    }
    
    @IBAction func selectLocation(_ sender: UIButton) {
        let locationPicker = LocationPickerViewController()
        
        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true
        
        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true
        
        locationPicker.mapType = .standard // default: .Hybrid
        
        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false
        
        locationPicker.searchBarPlaceholder = "Search for a location" // default: "Search or enter an address"
        
        locationPicker.searchHistoryLabel = "Search History" // default: "Search History"
        
        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600
        
        //Function run when location is selected
        locationPicker.completion = { location in
            self.myLocation = MyLocation(mark: (location?.placemark)!)
            self.locationLabel.text = self.myLocation!.name
        }
        
        navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        if (self.titleTextView.text == "" || self.sponsorTextView.text == "" || self.purposeTextView.text == "" || self.diseaseTextView.text == "") {
            
            let alert = UIAlertController(title: "Oops!", message: "Please enter all required information", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        } else if (self.myLocation == nil || self.date == nil) {
            let alert = UIAlertController(title: "Oops!", message: "Please enter a date and location for the event", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        } else {
        
            let title = self.titleTextView.text!
            let disease = self.diseaseTextView.text!
            let organization = self.sponsorTextView.text!
            let purpose = self.purposeTextView.text!
            
            db.createEvent(title: title, mylocation: myLocation!, date: date! as NSDate, disease: disease, organizer: organization, description: purpose)
        
            let alert = UIAlertController(title: "Event Created!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Great", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.clearTextFields()
        }
    }
    
    @IBAction func timePress(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "DateAndTime:", datePickerMode: UIDatePickerMode.dateAndTime, selectedDate: NSDate() as Date!, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.date = value as? Date

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "en_GB")
            dateFormatter.dateFormat = "hh:mm M/d"
            self.timeLabel.text = dateFormatter.string(from: self.date!)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
        datePicker?.minimumDate = NSDate(timeInterval: -secondsInWeek, since: NSDate() as Date) as Date!
        datePicker?.maximumDate = NSDate(timeInterval: secondsInWeek, since: NSDate() as Date) as Date!
        datePicker?.minuteInterval = 20
        
        datePicker?.show()
    }
    
    
}
