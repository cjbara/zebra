//
//  SignUpViewController1.swift
//  Zebra
//
//  Created by Cory Jbara on 2/6/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import Toast_Swift
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet var name: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var zipCode: UITextField!
    
    var profile = Profile()
    
    @IBAction func nextSignUpPage(_ sender: UIButton) {
        let n = name.text!
        let e = email.text!
        let p = password.text!
        let u = username.text!
        let z = zipCode.text!
        
        profile = Profile(name: n, email: e, username: u, password: p, zipCode: z)
        
        FIRAuth.auth()?.createUser(withEmail: e, password: p) { (user, error) in
            if error != nil {
                self.view.makeToast("Could not create user! This email is already registered.")
                self.email.text = ""
                self.password.text = ""
            } else {
                //Insert data into firebase
                
                //Segue to other Sign up VC
                self.performSegue(withIdentifier: "signUp1to2", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let vc = segue.destination as! SignUpDetailsViewController
        vc.profile = profile
    }
 

}
