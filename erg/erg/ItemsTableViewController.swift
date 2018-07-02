//
//  ItemsTableViewController.swift
//  ToDo App
//
//  Created by echessa on 8/11/16.
//  Copyright © 2016 Echessa. All rights reserved.
//

import UIKit

protocol ItemsViewControllerDelegate: class {
    var presenter: ItemsPresenterViewDelegate? { get set }
    func addWorkoutToView(workout: WorkoutDTO)
    func reloadTable()
    func signOut()
    func showAlert(_ alertVc: UIAlertController) 

    
    func showLoading()
    func dismissLoading()
}

class ItemsTableViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    @IBOutlet var typeFilter: UISegmentedControl!
    
    @IBOutlet var errorMessageLabel: UILabel!
    
    var presenter: ItemsPresenterViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()

        NotificationCenter.default.addObserver(self, selector: #selector(databaseLoaded), name: .databaseLoaded, object: nil)
     
        tableView.delegate = presenter!.datasource
        tableView.dataSource = presenter!.datasource
        reloadTable()
        
        primaryLabel.text = "Metres"
        secondaryLabel.text = "Time"
    }
    
    @objc
    func donePicker() {
    }
    
    @objc
    func databaseLoaded() {
        tableView.reloadData()
        self.dismissLoading()
    }

    // MARK: - Table view data source

    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddErgData" {
            if let vc = segue.destination as? AddErgDataViewController {
                vc.presenter = AddErgPresenter(itemsControllerDelegate: self)
                vc.presenter?.viewDelegate = vc
            }
        }
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
    
        if typeFilter.selectedSegmentIndex == 0 {
            presenter?.setFilter(nil)
            primaryLabel.text = "Time"
            secondaryLabel.text = "Metres"
            
        } else if typeFilter.selectedSegmentIndex == 1 {
            presenter?.setFilter(.distance)
            primaryLabel.text = "Metres"
            secondaryLabel.text = "Time"
            
        } else if typeFilter.selectedSegmentIndex == 2 {
            presenter?.setFilter(.time)
            primaryLabel.text = "Time"
            secondaryLabel.text = "Metres"
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
    }
}

extension ItemsTableViewController: ItemsViewControllerDelegate {
    
    func reloadTable() {
        tableView.reloadData()
        
        if tableView.numberOfSections == 0 {
            tableView.isHidden = true
            errorMessageLabel.text = "You have no workouts logged yet"
            errorMessageLabel.isHidden = false
        } else {
            tableView.isHidden = false
            errorMessageLabel.isHidden = true
        }
        
//        if let filter = self.presenter?.filterTitle {
//            filterValueLabel.attributedText = filter.apply(font: UIFont.regularFont(14))
//            filterTitleLabel.attributedText = "Current Filter:".apply(font: UIFont.boldFont(14))
//        } else {
//            filterValueLabel.text = ""
//            filterTitleLabel.text = ""
//        }
    }
    
    func addWorkoutToView(workout: WorkoutDTO) {
        presenter?.addWorkoutToDatabase(workout: workout)
    }
    
    func signOut() {
        performSegue(withIdentifier: "SignOut", sender: nil)
    }
}
