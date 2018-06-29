
//
//  SettingsViewController.swift
//  erg
//
//  Created by Christie on 16/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var formButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.layer.cornerRadius = 5
        emailButton.layer.cornerRadius = 5
        formButton.layer.cornerRadius = 5
        // https://goo.gl/forms/73NLNyTfXk5Vfzwj2
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        self.signOut()
        
    }
    
    @IBAction func formTapped(_ sender: Any) {
        if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScgi7g91EaJHDykxXr8mHinAx0R3htFi_MLQ6tNgVcbw2iyJg/viewform?usp=sf_link") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func emailTapped(_ sender: Any) {
 
        if MFMailComposeViewController.canSendMail() {
            let mailVc = MFMailComposeViewController()
            mailVc.mailComposeDelegate = self
            mailVc.setSubject("iRow app feedback")
            mailVc.setToRecipients(["irowapp@gmail.com"])
            
            self.present(mailVc, animated: true, completion: nil)
        }
    }
    
    func signOut() {
        if DatabaseRepo.shared.signOut() == nil {
            performSegue(withIdentifier: "SignOut", sender: nil)

        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        self.dismissView(self)
    }
}
