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

    private var rootReference: DatabaseReference! = Database.database().reference()
    private var sessionReference: DatabaseReference {
        return rootReference.child("users/\(self.user.uid)/sessions")
    }
    
    var user: User!
    var sessions = [Session]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!
    
    var viewDelegate: ItemsViewControllerDelegate?
    var datasource: ItemsDatasource
    
    private var viewFilter: SessionType?
    private var sessionViewFilter: String?
    private var expandedSessions: Set<Int> = Set<Int>()
    var sessionPickerValueArray: [String] {
        //TODO: update with real values using filter once db connected
        return sessions.filter { session -> Bool in
            return session.type == viewFilter?.rawValue
            }.flatMap({ (session) -> String? in
                return session.title
            })
    }

    var numberOfSessions: Int {
        return sessions.count
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
        startObservingDatabase()
    }
    
    func startObservingDatabase () {
        databaseHandle = sessionReference.observe(.value, with: { snapshot in
            var newSessions = [Session]()

            for sessionSnapshot in snapshot.children {
                let session = Session(snapshot: sessionSnapshot as! DataSnapshot)
                newSessions.append(session)
            }
            self.sessions = newSessions
            self.viewDelegate?.reloadTable()
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
        ref.child("users/\(self.user.uid)/sessions").removeObserver(withHandle: databaseHandle)

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
        let sessionDBO = Session(session: session)
        sessionReference.childByAutoId().child("title").setValue(sessionDBO)
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
