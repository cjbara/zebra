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

class SettingsViewController: UIViewController {
    
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
    @IBOutlet var selectDisease: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.initialize()
        
        aboutMeTextView.layer.cornerRadius = 4;
        aboutMeTextView.layer.borderColor = UIColor.black.cgColor
        aboutMeTextView.layer.borderWidth = 3.0
        
        aboutMeTextView.text = db.profile.aboutMe
        nameTextView.text = db.profile.name
        zipCodeTextView.text = db.profile.zipCode
        
        if db.profile.account! == "public" {
            accountType.selectedSegmentIndex = 0
        } else if db.profile.account! == "private" {
            accountType.selectedSegmentIndex = 1
        }
        
        if db.profile.privacy! == "name" {
            nameOptions.selectedSegmentIndex = 0
        } else if db.profile.privacy! == "username" {
            nameOptions.selectedSegmentIndex = 1
        }

        db.getDiseases()
    }
    
    @IBAction func navigationItemPicker(sender: UIButton) {
        ActionSheetStringPicker.show(withTitle: "Disease of Interest", rows: ["One", "Two", "A lot"], initialSelection: 1, doneBlock: {
            picker, value, index in
            
            print("value = \(value)")
            print("index = \(index)")
            print("picker = \(picker)")
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func updateInformation(_ sender: UIBarButtonItem) {
        //Insert data into Firebase
        let name = nameTextView.text!
        let zipCode = zipCodeTextView.text!
        let aboutMe = aboutMeTextView.text!
        
        let account = (accountType.selectedSegmentIndex == 0) ? "public" : "private"
        var privacy = (nameOptions.selectedSegmentIndex == 0) ? "name" : "username"
        
        if name == "" {
            privacy = "username"
        }
        
        db.updateUserData(name: name, zipCode: zipCode, about: aboutMe, account: account, privacy: privacy) { (success) in
            self.view.makeToast("Successfully updated user data", duration: 3.0, position: .center)
        }
        
    }
}
