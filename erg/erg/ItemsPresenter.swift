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

protocol ItemsPresenterViewDelegate: class {
    var viewDelegate: ItemsViewControllerDelegate? { get set }
    var datasource: ItemsDatasource { get }
    
    func addItemToDatabase(session: SessionDTO)
    func setFilter(_ sessionType: SessionType?)
    func signOut()
}

protocol ItemsPresenterDataDelegate {
    
    var sessionPickerValueArray: [String] { get }
    
    var numberOfSessions: Int { get }
    func rowsForSession(_ sessionIndex: Int) -> Int
    func setSessionTypeFromPicker(_ rowSelected: Int)

}

class ItemsPresenter: NSObject {

    var user: User!
    var items = [Item]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    var viewDelegate: ItemsViewControllerDelegate?
    var datasource: ItemsDatasource
    
    private var viewFilter: SessionType?
    private var sessionViewFilter: String?
    private var expandedSessions: Set<Int> = Set<Int>()
    var sessionPickerValueArray: [String] {
        //TODO: update with real values using filter once db connected
        return ["", ""]
    }

    var numberOfSessions: Int {
        return items.count
    }
    
    func rowsForSession(_ sessionIndex: Int) -> Int {
        if expandedSessions.contains(sessionIndex) {
            return 1 // TODO: with expanded session info on tap
        } else {
            return 1
        }
    }

    
    
    override init() {
        datasource = ItemsDatasource()
        super.init()
        datasource = ItemsDatasource(self)
    
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
            self.viewDelegate?.reloadTable()
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
    }
}

extension ItemsPresenter : ItemsPresenterDataDelegate {
    func setSessionTypeFromPicker(_ rowSelected: Int) {
        sessionViewFilter = sessionPickerValueArray[rowSelected]
        viewDelegate?.reloadTable()
    }
}

extension ItemsPresenter: ItemsPresenterViewDelegate {
    
    func setFilter(_ sessionType: SessionType?) {
        self.viewFilter = sessionType
        
    }

    func addItemToDatabase(session: SessionDTO) {
//        self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(userInput)
        self.viewDelegate?.reloadTable()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            viewDelegate?.signOut()
        } catch let error {
            assertionFailure("Error signing out: \(error)")
        }
    }
}
