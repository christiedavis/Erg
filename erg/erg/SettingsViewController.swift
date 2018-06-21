
//
//  SettingsViewController.swift
//  erg
//
//  Created by Christie on 16/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.layer.cornerRadius = 5
        
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        self.signOut()
    }
    
    func signOut() {
        
    }
}
