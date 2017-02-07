//
//  SignUpViewController2.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SignUpDetailsViewController: UIViewController {

    var profile = Profile()
    
    @IBOutlet var tellUsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if profile.name.isEmpty == false {
            tellUsLabel.text = "Tell us a bit about yourself, \(profile.name)"
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //Transition to Home VC
        self.performSegue(withIdentifier: "signUpToTabBar", sender: nil)
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
