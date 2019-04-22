//
//  HomeViewController.swift
//  erg
//
//  Created by Christie on 6/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var filterMenuButton: HomeButtonView!
    @IBOutlet weak var addErgButton: HomeButtonView!
    @IBOutlet weak var cameraButton: HomeButtonView!
    @IBOutlet weak var predictButton: HomeButtonView!
    @IBOutlet weak var settingsButton: HomeButtonView!
    
    @IBOutlet var lifetimeMetersLabel: UILabel!
    @IBOutlet var lifetimeTimeLbel: UILabel!
    
    weak var coordinator: DashboardCoordinatorProtocol?
    var presenter: ItemsPresenterViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        NotificationCenter.default.addObserver(self, selector: #selector(databaseLoaded), name: .databaseLoaded, object: nil)
        
//        filterMenuButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToFilter)))
//        addErgButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToAddErg)))
//        cameraButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCamera)))
//        predictButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToPredict)))
//        settingsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSettings)))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    func databaseLoaded() {
        var lifetimeMeters: Double = 0
        var lifetimeTime: Double = 0
        RepositoryFactory.shared.databaseRepo.pieces.forEach { (key, value) in
            value.forEach({ (piece) in
                if let distance = piece.distance {
                    lifetimeMeters += Double(distance) ?? 0
                }
                
                if let time = piece.time {
                    lifetimeTime += Double(time) ?? 0
                }
            })
        }
        lifetimeMetersLabel.text = "\(lifetimeMeters) meters"
        lifetimeTimeLbel.text = "\(lifetimeTime) minutes"
    }
    
    
}

extension HomeViewController { // Menu Actions
    @objc
    func goToFilter() {
        self.coordinator?.goToFilter()
    }
    
    @objc
    func goToAddErg() {
        self.coordinator?.goToAddErg()
    }
    
    @objc
    func goToCamera() {
        self.coordinator?.goToCamera()
        
    }
    
    @objc
    func goToPredict() {
        self.coordinator?.goToPredict()
    }
    
    @objc
    func goToSettings() {
       self.goToSettings()
    }
}

extension HomeViewController: ItemsViewControllerDelegate {
    
    func reloadTable() {
//        tableview.reloadData()
    }
    
    func addWorkoutToView(workout: WorkoutDTO) {
    }
    
    func signOut() {
        self.coordinator?.signOut()
    }
}

class HomeButtonView: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        switch self.tag {
        case 0:
            setup("WORKOUTS", #imageLiteral(resourceName: "Workout"))
        case 1:
            setup("ADD", #imageLiteral(resourceName: "Add"))
        case 2:
            setup("CAMERA", #imageLiteral(resourceName: "Camera"))
        case 3:
            setup("PREDICT", #imageLiteral(resourceName: "Predictions"))
        case 4:
            setup("SETTINGS", #imageLiteral(resourceName: "Settings"))
        default:
            break
        }
    }
    
    func setup(_ title: String, _ image: UIImage) {
        self.backgroundColor = UIColor.burntYellow
//        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
}
