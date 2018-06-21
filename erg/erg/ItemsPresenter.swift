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
}

protocol ItemsPresenterDataDelegate {
    
    var sessionPickerValueArray: [String] { get }
    
    var numberOfSessions: Int { get }
    func rowsForSession(_ sessionIndex: Int) -> Int
    func setSessionTypeFromPicker(_ rowSelected: Int)
    func workoutViewModelForSection(_ row: Int) -> WorkoutDTO?
}

class ItemsPresenter: NSObject {

//    private var user: User!
    private var sessions: [Session] {
        return DatabaseRepo.shared.sessions
    }
    private var pieces: [String: [Piece]] {
        return DatabaseRepo.shared.pieces
    }
//    private varref: DatabaseReference!
//    private var se ssionsDatabaseHandle: DatabaseHandle!
//    private var piecesDatabaseHandle: DatabaseHandle!

    var viewDelegate: ItemsViewControllerDelegate?
    var datasource: ItemsDatasource
    
    var filterTitle: String? = ""
    private var viewFilter: SessionType? {
        didSet {
            NSLog("hi")
            sessionViewFilter = nil 
        }
    }
    private var sessionViewFilter: String?
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
}

extension ItemsPresenter: ItemsPresenterDataDelegate {
    
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
        DatabaseRepo.shared.addWorkoutToDatabase(workout: workout)
        self.viewDelegate?.reloadTable()
    }
    
    func filter() {
        
    }
}

