//
//  AuthenticationService.swift
//  erg
//
//  Created by Christie Davis on 17/04/19.
//  Copyright © 2019 star. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

protocol AuthServiceProtocol: class {
    var userId: String { get }
    
    func signIn(email: String?, password: String?, callback: @escaping (() -> Void))
    func signOut() -> Error?
}


class AuthenticationService: AuthServiceProtocol {
    static var shared: AuthenticationService = AuthenticationService()

    private var user: User!

    init() {
        user = Auth.auth().currentUser

    }
    
    var userId: String {
        return user.uid
    }
    
    func signIn(email: String?, password: String?, callback: @escaping (() -> Void)) {
        guard let email = email,
            let password = password else {
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            
            callback()
//            guard let _ = user else {
//                if let error = error {
//                    if let errCode = AuthErrorCode(rawValue: error._code) {
//                        self.dismissLoading()
//                        switch errCode {
//                        case .userNotFound:
//                            self.showAlert("User account not found. Try registering")
//                        case .wrongPassword:
//                            self.showAlert("Incorrect username/password combination")
//                        default:
//                            self.showAlert("Error: \(error.localizedDescription)")
//                        }
//                    }
//                    return
//                }
//                assertionFailure("user and error are nil")
//                return
//            }
//            self.dismissLoading()
//            self.signIn()
        })
    }
    
    func signOut() -> Error? {
        do {
            try Auth.auth().signOut()
            return nil
            
        } catch let error {
            assertionFailure("Error signing out: \(error)")
            return error
        }
    }
}


