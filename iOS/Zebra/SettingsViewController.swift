//
//  SettingsViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 2/19/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import Toast_Swift

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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
