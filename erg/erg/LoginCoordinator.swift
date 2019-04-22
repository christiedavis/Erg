//
//  LoginCoordinator.swift
//  erg
//
//  Created by Christie Davis on 17/04/19.
//  Copyright © 2019 star. All rights reserved.
//

import UIKit

protocol LoginCoordinatorProtocol: FlowCoordinatorProtocol {
    func signup()
    func signedIn()
}

class LoginCoordinator {//: BaseCoordinator {
    weak var appCoordinator: AppCoordinatorDelegate?
    fileprivate weak var navigationController: UINavigationController?
}

extension LoginCoordinator: LoginCoordinatorProtocol {
    
    func enterNextFlow(navigationController: UINavigationController, sender: Any?) {
    
        self.navigationController = navigationController
        self.showLoginScreen()
    }
    
    private func showLoginScreen() {
        let loginVc = LoginViewController()
        loginVc.coordinator = self
        navigationController?.pushViewController(loginVc, animated: true)
    }
    
    func signup() {
        let signupVc = SignUpViewController()
        signupVc.coordinator = self
       
       navigationController?.present(signupVc, animated: true, completion: nil)
    }
    
    func signedIn() {
        self.appCoordinator?.enterNextFlow(currentCoordinator: self, sender: nil, with: self.navigationController)
    }
}
