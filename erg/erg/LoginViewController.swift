//
//  LoginViewController.swift
//  ToDo App
//
//  Created by echessa on 8/11/16.
//  Copyright © 2016 Echessa. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import YXWaveView

class LoginViewController: BaseViewController {
    
    var coordinator: LoginCoordinatorProtocol?
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet var signInButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet var waveView: UIView!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        emailField.textContentType = .username
        passwordField.textContentType = .password
        emailField.layer.cornerRadius = 3
        passwordField.layer.cornerRadius = 3
        
        signInButton.layer.cornerRadius = 5
        signupButton.layer.cornerRadius = 5

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        self.view.layoutIfNeeded()
        
        let waterView = YXWaveView(frame: waveView.frame, color: UIColor.darkBlue)
        waterView.backgroundColor = UIColor(red: 248/255, green: 64/255, blue: 87/255, alpha: 0)
        
        // Add WaveView
        self.view.addSubview(waterView)
        
        // Start wave
        waterView.start()
        
        self.dismissLoading()
    }

    @IBAction func didTapSignup(_ sender: Any) {
        self.coordinator?.signup()
    }
    
    @IBAction func didTapSignIn(_ sender: UIButton) {
        
        guard let email = emailField.text,
            let password = passwordField.text else {
                return
        }
        
        self.showLoading()
        
        RepositoryFactory.shared.authenticationRepo.signIn(email: email, password: password) { (error) in
            
            self.dismissLoading()
            self.showAlert("Incorrect username/password combination")

            if error == nil {
                self.coordinator?.signedIn()
                return
            }
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    self.dismissLoading()
                    switch errCode {
                    case .userNotFound:
                        self.showAlert("User account not found. Try registering")
                    case .wrongPassword:
                        self.showAlert("Incorrect username/password combination")
                    default:
                        self.showAlert("Error: \(error.localizedDescription)")
                    }
                }
                return
            }
            assertionFailure("user and error are nil")
            return
            
        }
    }

    @IBAction func didRequestPasswordReset(_ sender: UIButton) {
        let prompt = UIAlertController(title: "Reset your password", message: "Enter your email to reset your password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (action) in
            
            guard let email = prompt.textFields?[0].text else {
                return
            }
            self?.doResetPassword(email: email)
            
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }

    private func doResetPassword(email: String) {
        RepositoryFactory.shared.authenticationRepo.resetPassword(email: email, callback: { (error) in
            
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .userNotFound:
                        DispatchQueue.main.async {
                            self.showAlert("User account not found. Try registering")
                        }
                    default:
                        DispatchQueue.main.async {
                            self.showAlert("Error: \(error.localizedDescription)")
                        }
                    }
                }
                return
            } else {
                DispatchQueue.main.async {
                    self.showAlert("You'll receive an email shortly to reset your password.")
                }
            }
        })
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "iRow", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
