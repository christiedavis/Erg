//
//  SignUpViewController.swift
//  ToDo App
//
//  Created by echessa on 8/11/16.
//  Copyright © 2016 Echessa. All rights reserved.
//

import UIKit
import FirebaseAuth
import YXWaveView

class SignUpViewController: UIViewController {
    
    @IBOutlet var waveView: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.textContentType = .username
        passwordField.textContentType = .password
        emailField.layer.cornerRadius = 3
        passwordField.layer.cornerRadius = 3
        
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.layer.cornerRadius = 5

        self.view.layoutIfNeeded()
        
        let waterView = YXWaveView(frame: waveView.frame, color: UIColor.darkBlue)
        waterView.backgroundColor = UIColor(red: 248/255, green: 64/255, blue: 87/255, alpha: 0)
        self.view.addSubview(waterView)
        waterView.start()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .invalidEmail:
                        self.showAlert("Enter a valid email.")
                    case .emailAlreadyInUse:
                        self.showAlert("Email already in use.")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
            }
            self.signIn()
        })
    }
    
    @IBAction func didTapBackToLogin(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "To Do App", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func signIn() {
        _ = DatabaseRepo()
        performSegue(withIdentifier: "SignInFromSignUp", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInFromSignUp" {
            
            if let destinationNavigationController = segue.destination as? UINavigationController {
                if let targetController = destinationNavigationController.topViewController as? ItemsTableViewController {
                    let itemPresenter = ItemsPresenter()
                    itemPresenter.viewDelegate = targetController
                    targetController.presenter = itemPresenter
                }
            }
        }
    }
    
    @objc
    func dismissKeyboard() {
        
        if emailField.isFirstResponder {
            emailField.resignFirstResponder()
        }
        if passwordField.isFirstResponder {
            passwordField.resignFirstResponder()
        }
    }
}
