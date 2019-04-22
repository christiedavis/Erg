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

protocol DatabaseRepoProtocol {
    // cached data
    var sortedSessions: [Session] { get }
    var pieces: [String:[Piece]] { get }
    
    var lifetimeMeters: Double? { get }
    var lifetimeTime: Double? { get }
    
    func addWorkoutToDatabase(workout: WorkoutDTO)
    func delete(_ workout: WorkoutDTO?)

}

class DatabaseRepo {
    
    private var authService: AuthServiceProtocol
    
    private var sessions: [Session] = []
    public private(set) var pieces: [String: [Piece]] = [:]
    private var ref: DatabaseReference!
    private var sessionsDatabaseHandle: DatabaseHandle!
    private var piecesDatabaseHandle: DatabaseHandle!
    
    private var rootReference: DatabaseReference! = Database.database().reference()
    private var sessionReference: DatabaseReference {
        return rootReference.child("users/\(self.authService.userId)/sessions")
    }
    private var pieceReference: DatabaseReference {
        return rootReference.child("users/\(self.authService.userId)/pieces")
    }
    
    init(_ authDelegate: AuthServiceProtocol) {
        self.authService = authDelegate
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
  
        //TODO: check if i need to update this to go here
//        NotificationCenter.default.post(name: .databaseLoaded, object: nil)
    
    }
    
    func delete(_ workout: WorkoutDTO?) {
        if let id = workout?.session.id {
            pieceReference.child(id).removeValue()
            sessionReference.child(id).removeValue()
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

extension DatabaseRepo: DatabaseRepoProtocol {
    var lifetimeMeters: Double? {
        var meters: Double = 0
        
        self.pieces.forEach { (key, value) in
            value.forEach({ (piece) in
                if let distance = piece.distance {
                    meters += Double(distance) ?? 0
                }
            })
        }
        return meters
    }
    
    var lifetimeTime: Double? {
        var times: Double = 0
        
        self.pieces.forEach { (key, value) in
            value.forEach({ (piece) in
                
                if let time = piece.time {
                    times += Double(time) ?? 0
                }
            })
        }
        return times
    }
}
