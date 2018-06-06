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
    var filterTitle: String? { get }
    
    func addWorkoutToDatabase(workout: WorkoutDTO)
    func setFilter(_ sessionType: SessionType?)
    func signOut()
}

protocol ItemsPresenterDataDelegate {
    
    var sessionPickerValueArray: [String] { get }
    
    var numberOfSessions: Int { get }
    func rowsForSession(_ sessionIndex: Int) -> Int
    func setSessionTypeFromPicker(_ rowSelected: Int)
    func workoutViewModelForSection(_ row: Int) -> WorkoutDTO?
}

class ItemsPresenter: NSObject {

    private var rootReference: DatabaseReference! = Database.database().reference()
    private var sessionReference: DatabaseReference {
        return rootReference.child("users/\(self.user.uid)/sessions")
    }
    private var pieceReference: DatabaseReference {
        return rootReference.child("users/\(self.user.uid)/pieces")
    }
    
    private var user: User!
    private var sessions = [Session]()
    private var pieces = [String: [Piece]]()
    private var ref: DatabaseReference!
    private var sessionsDatabaseHandle: DatabaseHandle!
    private var piecesDatabaseHandle: DatabaseHandle!

    var viewDelegate: ItemsViewControllerDelegate?
    var datasource: ItemsDatasource
    
    var filterTitle: String? = ""
    private var viewFilter: SessionType?
    private var sessionViewFilter: String? {
        didSet {
            
        }
    }
    private var expandedSessions: Set<Int> = Set<Int>()
    var sessionPickerValueArray: [String] {
        if viewFilter == nil {
            return sessions.compactMap({ $0.title })
        }
        
        let filteredList = sessions.filter { session -> Bool in
            return session.type == viewFilter?.rawValue
            }.compactMap({ (session) -> String? in
                return session.title
            })
        
        return Array(Set(filteredList.map { $0 }))
    }
    
    var filteredSessions: [Session] {
        if viewFilter == nil {
            return sessions
        }
        
        if sessionViewFilter == nil {
            return sessions.compactMap({ (session) -> Session? in
                if session.type == viewFilter?.rawValue {
                    return session
                }
                return nil
            })
        }
        
        return sessions.filter({ (session) -> Bool in
            return session.title == sessionViewFilter
        })
    }

    var numberOfSessions: Int {
        return filteredSessions.count
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
    
    func sessionViewModelForRow(_ row: Int) -> SessionDTO? {
        return filteredSessions[row].asSessionDTO()
    }
    
    func workoutViewModelForSection(_ section: Int) -> WorkoutDTO? {

        let sessionId = filteredSessions[section].id ?? ""
        let pieceArray = pieces[sessionId] ?? []
        let session = filteredSessions[section]
        
        let workoutDto = WorkoutDTO(pieceArray, session)
        return workoutDto
    }
    
    deinit {
        sessionReference.removeObserver(withHandle: sessionsDatabaseHandle)
        pieceReference.removeObserver(withHandle: piecesDatabaseHandle)
    }
}

extension ItemsPresenter : ItemsPresenterDataDelegate {
    
    func setSessionTypeFromPicker(_ rowSelected: Int) {
        sessionViewFilter = sessionPickerValueArray[rowSelected]
        filterTitle = sessionPickerValueArray[rowSelected]
        viewDelegate?.reloadTable()
    }
}

extension ItemsPresenter: ItemsPresenterViewDelegate {
    
    func setFilter(_ sessionType: SessionType?) {
        self.viewFilter = sessionType
        viewDelegate?.reloadTable()
    }

    func addWorkoutToDatabase(workout: WorkoutDTO) {
        
        let sessionDBO = workout.sessionDBO
        let sessionID = sessionReference.childByAutoId()
        
        sessionID.setValue(sessionDBO)
        pieceReference.child(sessionID.key).setValue(workout.pieces)
        
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
    
    func filter() {
        
    }
}

// Mark: Database monitoring stuff
extension ItemsPresenter {
    
    func startObservingDatabase () {
        sessionsDatabaseHandle = sessionReference.observe(.value, with: { snapshot in
            var newSessions = [Session]()
            
            for sessionSnapshot in snapshot.children {
                let session = Session(snapshot: sessionSnapshot as! DataSnapshot)
                newSessions.append(session)
            }
            self.sessions = newSessions
        })
        
        
        piecesDatabaseHandle = pieceReference.observe(.value, with: { snapshot in
            var newPieces = [String : [Piece]]()
            
            for pieceSnapshot in snapshot.children {
                var pieceArray = [Piece]()

                let dataSnapshot = pieceSnapshot as! DataSnapshot
                for  child in dataSnapshot.children {
                    let piece = Piece(snapshot: child as! DataSnapshot)
                    pieceArray.append(piece)
                }
                newPieces[dataSnapshot.key] = pieceArray
                
            }
            self.pieces = newPieces
            self.viewDelegate?.reloadTable()
            self.viewDelegate?.dismissLoading()
        })
    }
}
