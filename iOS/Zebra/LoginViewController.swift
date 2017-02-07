//
//  LoginViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class LoginViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginPressed(_ sender: Any) {
        let email = username.text!
        let pw = password.text!
        FIRAuth.auth()?.signIn(withEmail: email, password: pw) { (user, error) in
            if (error == nil) {
                self.performSegue(withIdentifier: "loginToTabBar", sender: nil)
            } else {
                self.password.text = ""
                self.view.makeToast("Could not login! Check your username and password to make sure they match.")
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
