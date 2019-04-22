//
//  AppCoordinator.swift
//  erg
//
//  Created by Christie Davis on 17/04/19.
//  Copyright © 2019 star. All rights reserved.
//

import UIKit

protocol FlowCoordinatorProtocol: class {
    var appCoordinator: AppCoordinatorDelegate? { get set }
    func enterNextFlow(navigationController: UINavigationController, sender: Any?)
}

protocol AppCoordinatorDelegate: class {
    func enterNextFlow(currentCoordinator: FlowCoordinatorProtocol?, sender: Any?, with internalViewController: UINavigationController?)
}

extension AppCoordinatorDelegate {
    func enterNextFlow(currentCoordinator: FlowCoordinatorProtocol?, sender: Any?, with internalViewController: UINavigationController? = nil) {
        enterNextFlow(currentCoordinator: currentCoordinator, sender: sender, with: internalViewController)
    }
}


class AppCoordinator {
    
    private var window: UIWindow?
    fileprivate weak var navigationController: UINavigationController?
    
    fileprivate lazy var loginCoordinator: FlowCoordinatorProtocol = LoginCoordinator()
    fileprivate lazy var dashboardCoordinator: FlowCoordinatorProtocol = DashboardCoordinator()
    
    init() {        self.dashboardCoordinator.appCoordinator = self
        self.loginCoordinator.appCoordinator = self
    }
    
    func enterNextFlow(currentCoordinator: FlowCoordinatorProtocol?, sender: Any?, with internalViewController: UINavigationController? = nil) {
        // check for access, log in
        
        // Initial app load
        if window == nil || navigationController == nil {
            
            window = UIWindow(frame: UIScreen.main.bounds)
            let navController = UINavigationController()
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
            navigationController = navController
            navigationController?.pushViewController(LaunchViewController(), animated: false)
            
           // from launch
            self.enterNextFlow(currentCoordinator: currentCoordinator, sender: sender)
        }
        
        if let navController = internalViewController ?? self.navigationController {
            self.enterNextFlow(currentCoordinator: currentCoordinator, navigationController: navController, sender: sender)
        }
    }
    
    private func enterNextFlow(currentCoordinator: FlowCoordinatorProtocol?, navigationController: UINavigationController, sender: Any?) {
        if RepositoryFactory.shared.authenticationRepo.isSignedIn {
            self.dashboardCoordinator.enterNextFlow(navigationController: navigationController, sender: sender)
        } else {
            self.loginCoordinator.enterNextFlow(navigationController: navigationController, sender: sender)
        }
    }
}

extension AppCoordinator: AppCoordinatorDelegate {
    
}
