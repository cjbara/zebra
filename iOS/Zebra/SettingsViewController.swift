//
//  SettingsViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 2/19/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import Toast_Swift
import ActionSheetPicker_3_0

class SettingsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let db = Database.sharedInstance
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        db.signOut { (success) in
            if success == true {
                //Take user back to sign in page
                let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginVC")
                UIApplication.shared.keyWindow?.rootViewController = loginViewController
            } else {
                self.view.makeToast("Could not sign out", duration: 3.0, position: .center)
            }
        }
    }
    
    @IBOutlet var aboutMeTextView: UITextView!
    @IBOutlet var nameTextView: UITextField!
    @IBOutlet var zipCodeTextView: UITextField!
    @IBOutlet var accountType: UISegmentedControl!
    @IBOutlet var nameOptions: UISegmentedControl!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.initialize()
        
        nameTextView.delegate = self
        zipCodeTextView.delegate = self
        aboutMeTextView.delegate = self
        
        aboutMeTextView.layer.cornerRadius = 4;
        aboutMeTextView.layer.borderColor = UIColor.black.cgColor
        aboutMeTextView.layer.borderWidth = 3.0
        
        aboutMeTextView.text = db.profile.aboutMe
        nameTextView.text = db.profile.name
        zipCodeTextView.text = db.profile.zipCode
        
        if db.profile.privacy == true {
            accountType.selectedSegmentIndex = 0
        } else {
            accountType.selectedSegmentIndex = 1
        }
        
        if db.profile.showName == true {
            nameOptions.selectedSegmentIndex = 0
        } else {
            nameOptions.selectedSegmentIndex = 1
        }

    }
    
    @IBAction func updateInformation(_ sender: UIBarButtonItem) {
        //Insert data into Firebase
        let name = nameTextView.text!
        let zipCode = zipCodeTextView.text!
        let aboutMe = aboutMeTextView.text!
        
        let showName = (accountType.selectedSegmentIndex == 0) ? true : false
        let privacy = (nameOptions.selectedSegmentIndex == 0) ? true : false
        
        db.updateUserData(name: name, zipCode: zipCode, about: aboutMe, privacy: privacy, showName: showName) { (success) in
            self.view.makeToast("Successfully updated user data", duration: 3.0, position: .center)
        }
        
    }
}
