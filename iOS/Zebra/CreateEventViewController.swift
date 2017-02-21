//
//  CreateEventViewController.swift
//  Zebra
//
//  Created by Madelyn Nelson on 2/20/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class CreateEventViewController: UIViewController {
    
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var dateTextView: UITextView!
    @IBOutlet weak var diseaseTextView: UITextView!
    @IBOutlet weak var organizersTextView: UITextView!
    @IBOutlet weak var sponsorTextView: UITextView!
    @IBOutlet weak var purposeTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var db: Database = Database.sharedInstance
    
    var date: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        db.initialize()
        self.styleSubmitButton()
    }
    
    func clearTextFields() {
        self.titleTextView.text = ""
        self.addressTextView.text = ""
        self.dateTextView.text = ""
        self.diseaseTextView.text = ""
        self.organizersTextView.text = ""
        self.sponsorTextView.text = ""
        self.purposeTextView.text = ""
    }
    
    func styleSubmitButton() {
        self.submitButton.backgroundColor = UIColor.green
        self.submitButton.layer.cornerRadius = 5
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        
        if (self.titleTextView.text == "" || self.sponsorTextView.text == "" || self.dateTextView.text == "" || self.purposeTextView.text == "" || self.addressTextView.text == "") {
            
            let alert = UIAlertController(title: "Oops!", message: "Please enter all required information", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        else {
        
            let title = self.titleTextView.text
            let disease = self.diseaseTextView.text
            //let organization = self.organizersTextView.text
            //let sponsor = self.sponsorTextView.text
            let purpose = self.purposeTextView.text
        
        
            let org = Organization(name: "Madelyn", username: "mnelso12") // TODO
            let isPublic = true // TODO
            let location = Location(latitude:45, longitude:-21) // TODO
        
            let taggedPeople = [String]() // TODO
            let taggedOrgs = [String]() // TODO
        
            db.createEvent(title: title!, location: location, date: self.date as NSDate, disease: disease!, organizer: org, taggedPeople: taggedPeople, taggedOrganizations: taggedOrgs, description: purpose!, isPublic: isPublic)
        
            let alert = UIAlertController(title: "Event Created!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Great", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            self.clearTextFields()
        }
    }
    
    
    /*
    @IBAction func datePress(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.date, selectedDate: NSDate() as Date!, doneBlock: {
        picker, value, index in
        
        print("value = \(value)")
        print("index = \(index)")
        print("picker = \(picker)")
        return
    }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
        datePicker?.minimumDate = NSDate(timeInterval: -secondsInWeek, since: NSDate() as Date) as Date!
        datePicker?.maximumDate = NSDate(timeInterval: secondsInWeek, since: NSDate() as Date) as Date!
        
        datePicker?.show()
     
     /*
     let datePicker = ActionSheetDatePicker(title: "Time:", datePickerMode: UIDatePickerMode.time, selectedDate: NSDate() as Date!, target: self, action: Selector(("datePicked:")), origin: (sender as AnyObject).superview!?.superview)
     
     datePicker?.minuteInterval = 30
     
     datePicker?.show()
     */

    }
 */
    
    @IBAction func timePress(_ sender: Any) {
        let datePicker = ActionSheetDatePicker(title: "DateAndTime:", datePickerMode: UIDatePickerMode.dateAndTime, selectedDate: NSDate() as Date!, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            
            self.date = value as! Date

            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "en_GB")
            dateFormatter.dateFormat = "hh:mm M/d"
            self.dateTextView.text = dateFormatter.string(from: self.date)
            
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: (sender as AnyObject).superview!?.superview)
        let secondsInWeek: TimeInterval = 7 * 24 * 60 * 60;
        datePicker?.minimumDate = NSDate(timeInterval: -secondsInWeek, since: NSDate() as Date) as Date!
        datePicker?.maximumDate = NSDate(timeInterval: secondsInWeek, since: NSDate() as Date) as Date!
        datePicker?.minuteInterval = 20
        
        datePicker?.show()
        
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
}
