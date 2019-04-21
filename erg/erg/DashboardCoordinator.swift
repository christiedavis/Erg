//
//  DashboardCoordinator.swift
//  erg
//
//  Created by Christie Davis on 17/04/19.
//  Copyright © 2019 star. All rights reserved.
//

import UIKit

protocol DashboardCoordinatorProtocol: FlowCoordinatorProtocol {
    
}

class DashboardCoordinator {//: BaseCoordinator {
    
    fileprivate weak var navigationController: UINavigationController?
}

extension DashboardCoordinator: DashboardCoordinatorProtocol {
    func enterNextFlow(navigationController: UINavigationController, sender: Any?) {
      
        self.navigationController = navigationController
        self.goToHome()
        
    }
    
    private func goToHome() {
        let loginVc = HomeViewController()
        navigationController?.pushViewController(loginVc, animated: true)
    }
}
