//
//  DatabaseRepo.swift
//  erg
//
//  Created by Christie on 21/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class DatabaseRepo {
    static var shared: DatabaseRepo = DatabaseRepo()
    
    private var user: User!
    private var sessions: [Session] = []
    public private(set) var pieces: [String: [Piece]] = [:]
    private var ref: DatabaseReference!
    private var sessionsDatabaseHandle: DatabaseHandle!
    private var piecesDatabaseHandle: DatabaseHandle!
    
    private var rootReference: DatabaseReference! = Database.database().reference()
    private var sessionReference: DatabaseReference {
        return rootReference.child("users/\(self.user.uid)/sessions")
    }
    private var pieceReference: DatabaseReference {
        return rootReference.child("users/\(self.user.uid)/pieces")
    }
    
    init() {
        user = Auth.auth().currentUser
        startObservingDatabase()
    }

    deinit {
        sessionReference.removeObserver(withHandle: sessionsDatabaseHandle)
        pieceReference.removeObserver(withHandle: piecesDatabaseHandle)
    }
    
    var sortedSessions: [Session] {
        return self.sessions.sorted { (first, second) -> Bool in
            guard
                let firstDate = first.date,
                let secondDate = second.date
                else {
                    return false
            }
            return firstDate.compare(secondDate) == ComparisonResult.orderedDescending
        }
    }
    
    func addWorkoutToDatabase(workout: WorkoutDTO) {
        let sessionDBO = workout.sessionDBO
        let sessionID = sessionReference.childByAutoId()
        
        sessionID.setValue(sessionDBO)
        pieceReference.child(sessionID.key).setValue(workout.pieces)
    
    }
    
    func delete(_ workout: WorkoutDTO?) {
        if let id = workout?.session.id {
            pieceReference.child(id).removeValue()
            sessionReference.child(id).removeValue()
        }
    }
    
    func signOut() -> Error? {
        do {
            try Auth.auth().signOut()
            return nil
            
        } catch let error {
            assertionFailure("Error signing out: \(error)")
            return error
        }
    }
}

// Mark: Database monitoring stuff
extension DatabaseRepo {
    
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
            
            NotificationCenter.default.post(name: .databaseLoaded, object: nil)

        })
    }
}

