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

    private var rootReference: DatabaseReference! = Database.database().reference()
    private var sessionReference: DatabaseReference {
        return rootReference.child("users/\(self.user.uid)/sessions")
    }
    
    var user: User!
    var items = [Item]()
//    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var sessionPickerView: UIPickerView!

    var presenter: ItemsPresenterViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = Auth.auth().currentUser
//        ref = Database.database().reference()
        startObservingDatabase()
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

    func startObservingDatabase () {
        databaseHandle = rootReference.child("users/\(self.user.uid)/items").observe(.value, with: { (snapshot) in
            var newItems = [Item]()

            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                newItems.append(item)
            }

            self.items = newItems
            self.tableView.reloadData()

        })
        
//        databaseHandle = sessionReference.observe(.value, with: { snapshot in
//            var newSessions = [ErgSessionModel]()
//            
//            for sessionSnapshot in snapshot.children {
//                let session = ErgSessionModel(snapshot: sessionSnapshot as! DataSnapshot)
//                newSessions.append(session)
//            }
//            self.ergSessions = newSessions
//        })
        
    }

    deinit {
//        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
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
