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
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var sessionPickerView: UIPickerView!
    
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var filterValueLabel: UILabel!
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    @IBOutlet var typeFilter: UISegmentedControl!
    
    var presenter: ItemsPresenterViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.showLoading()

        sessionPickerView.delegate = presenter!.datasource
        sessionPickerView.dataSource = presenter!.datasource
        sessionPickerView.isHidden = true
        sessionPickerView.showsSelectionIndicator = true
        sessionPickerView.backgroundColor = UIColor.black
    
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .red
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector
            (donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        tableView.delegate = presenter!.datasource
        tableView.dataSource = presenter!.datasource
        tableView.reloadData()
        
        primaryLabel.text = "Metres"
        secondaryLabel.text = "Time"
    }
    
    @objc
    func donePicker() {
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
            primaryLabel.text = "Metres"
            secondaryLabel.text = "Time"
            
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
        sessionPickerView.isHidden = false
        sessionPickerView.reloadAllComponents()
    }
}

extension ItemsTableViewController: ItemsViewControllerDelegate {
    
    func reloadTable() {
        sessionPickerView.isHidden = true
        
        tableView.reloadData()
        
        if let filter = self.presenter?.filterTitle {
            filterValueLabel.attributedText = filter.apply(font: UIFont.regularFont(14))
            filterTitleLabel.attributedText = "Current Filter:".apply(font: UIFont.boldFont(14))
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
