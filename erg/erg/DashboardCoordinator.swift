//
//  DashboardCoordinator.swift
//  erg
//
//  Created by Christie Davis on 17/04/19.
//  Copyright © 2019 star. All rights reserved.
//

import UIKit

protocol DashboardCoordinatorProtocol: FlowCoordinatorProtocol {
    var dashBoardViewControllers: [UIViewController] { get }
    func goToFilter()
    func goToAddErg()
    func goToCamera()
    func goToPredict()
    func goToSettings()
    
    func signOut()
}

class DashboardCoordinator {
    var appCoordinator: AppCoordinatorDelegate?
    fileprivate weak var navigationController: UINavigationController?
}

extension DashboardCoordinator: DashboardCoordinatorProtocol {

    func enterNextFlow(navigationController: UINavigationController, sender: Any?) {
      
        self.navigationController = navigationController
        self.goToHome()
    }
    
    private func goToHome() {
        let viewController = DashboardViewController()
        viewController.coordinator = self
        viewController.setViewControllers([self.workoutsViewController(),
                                            self.addErgViewController(),
                                            self.cameraViewController(),
                                            self.predictViewController(),
                                            self.settingsViewController()], animated: true)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToFilter() {
        let viewController = ItemsTableViewController()
        let itemPresenter = ItemsPresenter()
        
        itemPresenter.viewDelegate = viewController
        viewController.presenter = itemPresenter
        navigationController?.pushViewController(viewController, animated: true)

    }
    
    func goToAddErg() {
        let viewController = AddErgDataViewController()
//            let itemPresenter = AddErgPresenter(itemsControllerDelegate: self)
//            itemPresenter.viewDelegate = viewController
//            viewController.presenter = itemPresenter
    }
    
    func goToCamera() {
        let viewController = CameraViewController()
        navigationController?.pushViewController(viewController, animated: true)

    }
    
    func goToPredict() {
        
    }
    
    func goToSettings() {
        
    }

    func signOut() {
        appCoordinator?.enterNextFlow(currentCoordinator: self, sender: nil, with: self.navigationController)
    }
}

extension DashboardCoordinator {
    // Set up tabs
    var dashBoardViewControllers: [UIViewController] {
        
        return [cameraViewController()]
    }
    
    private func workoutsViewController() -> UIViewController {
        let viewController = ItemsTableViewController()
        viewController.tabBarItem = UITabBarItem(title: "dashboards.tabs.workouts".localized, image: #imageLiteral(resourceName: "Workout"), selectedImage: #imageLiteral(resourceName: "Workout"))
        //        viewController.tabBarItem.tag = Constants.HomeTabBarTag.home
        return viewController
    }
    
    private func addErgViewController() -> UIViewController {
        let viewController = AddErgDataViewController()
        viewController.tabBarItem = UITabBarItem(title: "dashboards.tabs.adderg".localized, image: #imageLiteral(resourceName: "Add"), selectedImage: #imageLiteral(resourceName: "Add"))
        //        viewController.tabBarItem.tag = Constants.HomeTabBarTag.home
        return viewController
    }
    
    private func cameraViewController() -> UIViewController {
        let viewController = CameraViewController()
        viewController.tabBarItem = UITabBarItem(title: "dashboards.tabs.camera".localized, image: #imageLiteral(resourceName: "Camera"), selectedImage: #imageLiteral(resourceName: "Camera"))
//        viewController.tabBarItem.tag = Constants.HomeTabBarTag.home
        return viewController

    }
    
    private func predictViewController() -> UIViewController {
        let viewController = MachineLearningViewController()
        viewController.tabBarItem = UITabBarItem(title: "dashboards.tabs.predict".localized, image: #imageLiteral(resourceName: "Predictions"), selectedImage: #imageLiteral(resourceName: "Predictions"))
        //        viewController.tabBarItem.tag = Constants.HomeTabBarTag.home
        return viewController
    }
    
    private func settingsViewController() -> UIViewController {
        let viewController = SettingsViewController()
        viewController.tabBarItem = UITabBarItem(title: "dashboards.tabs.settings".localized, image: #imageLiteral(resourceName: "Settings"), selectedImage: #imageLiteral(resourceName: "Settings"))
        //        viewController.tabBarItem.tag = Constants.HomeTabBarTag.home
        return viewController
    }
}
