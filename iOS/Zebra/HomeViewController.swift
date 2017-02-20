//
//  HomeViewController.swift
//  Zebra
//
//  Created by Cory Jbara on 2/19/17.
//  Copyright © 2017 coryjbara. All rights reserved.
//

import UIKit
import Toast_Swift

class HomeViewController: UIViewController {
    
    var db: Database = Database.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        let message = "Welcome, \(db.profile.username)"
        self.view.makeToast(message, duration: 3.0, position: .center)
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
