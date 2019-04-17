//
//  LoginCoordinator.swift
//  erg
//
//  Created by Christie Davis on 17/04/19.
//  Copyright © 2019 star. All rights reserved.
//

import UIKit

protocol LoginCoordinatorProtocol: FlowCoordinatorProtocol {

}

class LoginCoordinator {//: BaseCoordinator {
    
    fileprivate weak var navigationController: UINavigationController?
}

extension LoginCoordinator: LoginCoordinatorProtocol {
    func enterNextFlow(navigationController: UINavigationController, sender: Any?) {
    
        self.navigationController = navigationController
        self.showLoginScreen()
    }
    
    private func showLoginScreen() {
        let loginVc = LoginViewController()
        navigationController?.pushViewController(loginVc, animated: true)
    }
}
