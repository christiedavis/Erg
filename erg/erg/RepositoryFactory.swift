//
//  RepositoryFactory.swift
//  erg
//
//  Created by Christie Davis on 17/04/19.
//  Copyright © 2019 star. All rights reserved.
//

import UIKit

protocol RepositoryFactoryProtocol {
    var databaseRepo: DatabaseRepoProtocol { get }
    var authenticationRepo: AuthServiceProtocol { get }
}

class RepositoryFactory: RepositoryFactoryProtocol {

    private static var sharedInstance: RepositoryFactory?
    public static var shared: RepositoryFactory {
        if let instance = sharedInstance {
            return instance
        }
        let instance = RepositoryFactory()
        sharedInstance = instance
        return instance
    }
    
    internal private(set) var databaseRepo: DatabaseRepoProtocol
    internal private(set) var authenticationRepo: AuthServiceProtocol // todo make a repo with services
    
    init() {
        let authService = AuthenticationService()
        self.authenticationRepo = authService
        self.databaseRepo = DatabaseRepo(authService)

    }
}

