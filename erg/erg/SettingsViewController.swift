
//
//  SettingsViewController.swift
//  erg
//
//  Created by Christie on 16/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit
import MessageUI
import YXWaveView

class SettingsViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    @IBOutlet var formButton: UIButton!
    @IBOutlet var waterView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logoutButton.layer.cornerRadius = 5
        emailButton.layer.cornerRadius = 5
        formButton.layer.cornerRadius = 5
        
        let waveView = YXWaveView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: waterView.frame.height), color: UIColor.darkBlue)
        waveView.backgroundColor = UIColor(red: 248/255, green: 64/255, blue: 87/255, alpha: 0)
        
        // Add WaveView
        self.waterView.addSubview(waveView)
        
        // Start wave
        waveView.start()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        self.signOut()
    }
    
    @IBAction func formTapped(_ sender: Any) {
        if let url = URL(string: "settings.quiz.link".localized) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func emailTapped(_ sender: Any) {
 
        if MFMailComposeViewController.canSendMail() {
            let mailVc = MFMailComposeViewController()
            mailVc.mailComposeDelegate = self
            mailVc.setSubject("settings.mail.subject".localized)
            mailVc.setToRecipients(["settings.mail.recipient"])
            
            self.present(mailVc, animated: true, completion: nil)
        }
    }
    
    func signOut() {
        RepositoryFactory.shared.authenticationRepo.signOut()
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    }
}
