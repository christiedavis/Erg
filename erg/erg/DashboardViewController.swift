//
//  DashboardViewController.swift
//  erg
//
//  Created by Christie Davis on 22/04/19.
//  Copyright © 2019 star. All rights reserved.
//

import UIKit

class DashboardViewController: UITabBarController {

    var coordinator: DashboardCoordinatorProtocol?
    var presenter: WorkoutPresenterViewDelegate?
    
//    @IBOutlet var lifetimeMetersLabel: UILabel!
//    @IBOutlet var lifetimeTimeLbel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(databaseLoaded), name: .databaseLoaded, object: nil)

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    func goToTab(_ tab: DashboardViewControllerTab) {
//        selectedIndex = tab.rawValue
//    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func databaseLoaded() {
//        if let lifetimeMeters = RepositoryFactory.shared.databaseRepo.lifetimeMeters {
//            lifetimeMetersLabel.text = "\(lifetimeMeters) meters"
//        }
//        if let lifetimeTime = RepositoryFactory.shared.databaseRepo.lifetimeTime {
//
//            lifetimeTimeLbel.text = "\(lifetimeTime) minutes"
//        }
    }
}
