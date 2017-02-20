//
//  SignUpViewController1.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import Toast_Swift

class SignUpViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var password2TextField: UITextField!
    
    var db: Database = Database.sharedInstance
    
    @IBAction func nextSignUpPage(_ sender: UIButton) {
        self.view.makeToastActivity(.center)
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let password2 = password2TextField.text!
        let username = usernameTextField.text!
        
        if email == "" {
            self.view.hideToastActivity()
            self.view.makeToast("Please enter an email address", duration: 3.0, position: .center)
            return
        }
        if username == "" {
            self.view.hideToastActivity()
            self.view.makeToast("Please enter a username", duration: 3.0, position: .center)
            return
        }
        if password == "" {
            self.view.hideToastActivity()
            self.view.makeToast("Please enter a password", duration: 3.0, position: .center)
            return
        }
        if password.characters.count < 6 {
            self.view.hideToastActivity()
            self.view.makeToast("Your password must be at least 6 characters", duration: 3.0, position: .center)
            self.passwordTextField.text = ""
            self.password2TextField.text = ""
            return
        }
        
        //Check if passwords are the same
        if password != password2 {
            self.view.hideToastActivity()
            self.view.makeToast("Your passwords do not match", duration: 3.0, position: .center)
            self.passwordTextField.text = ""
            self.password2TextField.text = ""
            return
        }
        
        //Check if username already exists
        db.checkUsername(username: username) { (userExists) in
            if userExists == true {
                self.view.hideToastActivity()
                self.view.makeToast("This username is taken, please enter a new username", duration: 3.0, position: .center)
                self.usernameTextField.text = ""
            } else {
                //Create the user
                self.db.createUser(email: email, password: password, username: username, callback: { (success) in
                    if success == false {
                        self.view.hideToastActivity()
                        self.view.makeToast("Could not create user! This email is already registered.", duration: 3.0, position: .center)
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.password2TextField.text = ""
                    } else {
                        self.view.hideToastActivity()
                        self.performSegue(withIdentifier: "signUp1to2", sender: nil)
                    }
                })

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller
        //let vc = segue.destination as! SignUpDetailsViewController
        
    }
 

}
