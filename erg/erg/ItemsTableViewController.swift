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
//    func addItemToView(session: SessionDTO)
    func reloadTable()
    func signOut()
}

class ItemsTableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var sessionPickerView: UIPickerView!

    var presenter: ItemsPresenterViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
//        self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(userInput)
    }

   
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddErgData" {
            if let vc = segue.destination as? AddErgDataViewController {
               vc.delegate = self
            }
        }
    }
    
    @IBAction func filterButtonTapped(_ sender: Any) {
        sessionPickerView.isHidden = false
    }
}

extension ItemsTableViewController: ItemsViewControllerDelegate {
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func addItemToView(session: SessionDTO) {
        
        presenter?.addItemToDatabase(session: session)
        //                    self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(userInput)

    }
    
    func signOut() {
        performSegue(withIdentifier: "SignOut", sender: nil)
    }
}
