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
    
    var isSignedIn: Bool { get }
    
    func signIn(email: String, password: String, callback: @escaping ((Error?) -> Void))
    func signUp(email: String, password: String, callback: @escaping ((Error?) -> Void))
    
    func resetPassword(email: String, callback: @escaping ((Error?) -> Void))
    func signOut() -> Error?
}

class AuthenticationService: AuthServiceProtocol {
    static var shared: AuthenticationService = AuthenticationService()

    private var user: User?

    init() {
        user = Auth.auth().currentUser
    }
    
    var isSignedIn: Bool {
        return self.user != nil
    }
    
    var userId: String {
        return user?.uid ?? "NONE"
    }
    
    func signIn(email: String, password: String, callback: @escaping ((Error?) -> Void)) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authDataResult, error) in
            
            self.user = authDataResult?.user
            
            callback(error)
        })
    }
    
    func signUp(email: String, password: String, callback: @escaping ((Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            callback(error)
        })
    }
    
    
    func resetPassword(email: String, callback: @escaping ((Error?) -> Void)) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            callback(error)
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


