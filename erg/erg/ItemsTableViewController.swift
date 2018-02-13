//
//  ItemsTableViewController.swift
//  ToDo App
//
//  Created by echessa on 8/11/16.
//  Copyright © 2016 Echessa. All rights reserved.
//

import UIKit

protocol ItemsViewControllerDelegate: class {
    var presenter: ItemsPresenterDelegate? { get set }
//    func addItemToView(session: SessionDTO)
    func reloadTable()
}

class ItemsTableViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var sessionPickerView: UIPickerView!

    var presenter: ItemsPresenterDelegate?
    
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
        presenter!.signOut()
        
       
    }

    @IBAction func didTapAddItem(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ShowAddErgData", sender: self)
        
//        let prompt = UIAlertController(title: "To Do App", message: "To Do Item", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//            let userInput = prompt.textFields![0].text
//            if (userInput!.isEmpty) {
//                return
//            }
//            self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(userInput)
//        }
//        prompt.addTextField(configurationHandler: nil)
//        prompt.addAction(okAction)
//        present(prompt, animated: true, completion: nil);
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
        
    }
    
    func addItemToView(session: SessionDTO) {
        
        presenter?.addItemToView(session: session)
        //                    self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(userInput)

    }
}
