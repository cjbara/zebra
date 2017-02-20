//
//  LoginViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import Toast_Swift

class LoginViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    var db: Database = Database.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.initialize()
    }

    @IBAction func loginPressed(_ sender: Any) {
        self.view.makeToastActivity(.center)
        let email = username.text!
        let password = self.password.text!
        db.signIn(email: email, password: password) { (success) in
            if success == true {
                self.view.hideToastActivity()
                self.performSegue(withIdentifier: "loginToTabBar", sender: nil)
            } else {
                self.view.hideToastActivity()
                self.password.text = ""
                self.view.makeToast("Could not login! Check your email and password to make sure they match.")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
