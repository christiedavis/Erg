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
    
    func showLoading()
    func dismissLoading()
}

class ItemsTableViewController: BaseViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var sessionPickerView: UIPickerView!
    
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var filterValueLabel: UILabel!
    
    var presenter: ItemsPresenterViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showLoading()

        //TODO: crashed on sign up
        sessionPickerView.delegate = presenter!.datasource
        sessionPickerView.dataSource = presenter!.datasource
        sessionPickerView.isHidden = true
        sessionPickerView.backgroundColor = UIColor.lightGray

        tableView.delegate = presenter!.datasource
        tableView.dataSource = presenter!.datasource
    }

    // MARK: - Table view data source

    @IBAction func didTapSignOut(_ sender: UIBarButtonItem) {
        presenter?.signOut()
    }

    @IBAction func didTapAddItem(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ShowAddErgData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddErgData" {
            if let vc = segue.destination as? AddErgDataViewController {
               vc.delegate = self
                vc.presenter = AddErgPresenter()
                vc.presenter?.viewDelegate = vc
            }
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        sessionPickerView.isHidden = false
        sessionPickerView.reloadAllComponents()
    }
}

extension ItemsTableViewController: ItemsViewControllerDelegate {
    
    func reloadTable() {
        tableView.reloadData()
        if let filter = self.presenter?.filterTitle {
            filterValueLabel.attributedText = filter.apply(font: UIFont.regularFont(14))
            filterTitleLabel.attributedText = filter.apply(font: UIFont.boldFont(14))
        } else {
            filterValueLabel.text = ""
            filterTitleLabel.text = ""
        }
    }
    
    func addWorkoutToView(workout: WorkoutDTO) {
        presenter?.addWorkoutToDatabase(workout: workout)
    }
    
    func signOut() {
        performSegue(withIdentifier: "SignOut", sender: nil)
    }
}
