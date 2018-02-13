//
//  ItemsPresenter.swift
//  erg
//
//  Created by Christie Davis on 12/02/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

protocol ItemsPresenterDelegate: class {
    var viewDelegate: ItemsViewControllerDelegate? { get set }
    var datasource: ItemsDatasource { get }
    
    func addItemToView(session: SessionDTO)
    
    func signOut()

}
class ItemsPresenter: NSObject {

    var user: User!
    var items = [Item]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    var viewDelegate: ItemsViewControllerDelegate?
    var datasource: ItemsDatasource = ItemsDatasource()
    
    override init() {
        super.init()
    
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        startObservingDatabase()
    }
    
    func startObservingDatabase () {
        databaseHandle = ref.child("users/\(self.user.uid)/items").observe(.value, with: { (snapshot) in
            var newItems = [Item]()
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                newItems.append(item)
            }
            
            self.items = newItems
            // TODO: Reload tableself.tableView.reloadData()
            self.viewDelegate?.reloadTable()
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
    }
}

extension ItemsPresenter: ItemsPresenterDelegate {
    func addItemToView(session: SessionDTO) {
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            // TODO: sign out segue
//            performSegue(withIdentifier: "SignOut", sender: nil)
        } catch let error {
            assertionFailure("Error signing out: \(error)")
        }
    }
}
