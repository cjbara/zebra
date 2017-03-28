//
//  SignUpViewController2.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import Toast_Swift
import ActionSheetPicker_3_0

class SignUpDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var db: Database = Database.sharedInstance
    
    @IBOutlet var aboutMeTextView: UITextView!
    @IBOutlet var nameTextView: UITextField!
    @IBOutlet var zipCodeTextView: UITextField!
    @IBOutlet var accountType: UISegmentedControl!
    @IBOutlet var nameOptions: UISegmentedControl!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.initialize()
        
        aboutMeTextView.delegate = self
        nameTextView.delegate = self
        zipCodeTextView.delegate = self
        
        aboutMeTextView.layer.cornerRadius = 4;
        aboutMeTextView.layer.borderColor = UIColor.black.cgColor
        aboutMeTextView.layer.borderWidth = 3.0
        
        if nameTextView.text == "" {
            nameOptions.selectedSegmentIndex = 1
        }
        
        accountType.selectedSegmentIndex = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let message = "Welcome to Zebra, \(db.profile.username)"
        self.view.makeToast(message, duration: 3.0, position: .center)
    }

    @IBAction func completeSignUp(_ sender: Any) {
        //Insert data into Firebase
        let name = nameTextView.text!
        let zipCode = zipCodeTextView.text!
        let aboutMe = aboutMeTextView.text!
        
        let privacy = (accountType.selectedSegmentIndex == 0) ? true : false
        let showName = (nameOptions.selectedSegmentIndex == 0) ? true : false
        
        db.updateUserData(name: name, zipCode: zipCode, about: aboutMe, privacy: privacy, showName: showName) { (success) in
            //Transition to Home VC
            self.db.getPeople()
            self.db.getEvents()
            self.db.getOrganizations()
            self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
