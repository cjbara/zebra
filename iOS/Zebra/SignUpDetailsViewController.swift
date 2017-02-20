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

class SignUpDetailsViewController: UIViewController {

    var db: Database = Database.sharedInstance
    
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
        
        if nameTextView.text == "" {
            nameOptions.selectedSegmentIndex = 1
        }
        
        accountType.selectedSegmentIndex = 1
        
        db.getDiseases()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let message = "Welcome to Zebra, \(db.profile.username)"
        self.view.makeToast(message, duration: 3.0, position: .center)
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

    @IBAction func completeSignUp(_ sender: Any) {
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
            //Transition to Home VC
            self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
        }
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
