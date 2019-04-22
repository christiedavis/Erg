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

enum OrderingByType: Int {
    case date
    case time
    case distance
    case split
    case rate
}

protocol ItemsPresenterViewDelegate: class {

    var viewDelegate: ItemsViewControllerDelegate? { get set }
    var datasource: ItemsDatasource { get }
    var filterTitle: String? { get }
    
    func addWorkoutToDatabase(workout: WorkoutDTO)
    func setFilter(_ sessionType: SessionType?)
    func setOrderingBy(_ orderType: OrderingByType)
}

protocol ItemsPresenterDataDelegate {
    
    var sessionPickerValueArray: [String] { get }
    var filter: SessionType? { get }
    var numberOfSessions: Int { get }
    
    func rowsForSession(_ sessionIndex: Int) -> Int
    func setSessionTypeFromPicker(_ rowSelected: Int)
    func workoutViewModelForSection(_ row: Int) -> WorkoutDTO?
    func deleteWorkout(_ section: Int)
}

class ItemsPresenter: NSObject {

    private var sessions: [Session] {
        return RepositoryFactory.shared.databaseRepo.sortedSessions
    }
    private var pieces: [String: [Piece]] {
        return RepositoryFactory.shared.databaseRepo.pieces
    }

    var viewDelegate: ItemsViewControllerDelegate?
    var datasource: ItemsDatasource
    
    var orderByType: OrderingByType = .date
    var filterTitle: String? = ""
    var filter: SessionType? {
        return viewFilter
    }
    private var viewFilter: SessionType? {
        didSet {
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

        if section < filteredSessions.count && section >= 0 {
        
            let sessionId = filteredSessions[section].id ?? ""
            let pieceArray = pieces[sessionId] ?? []
            let session = filteredSessions[section]
            
            let workoutDto = WorkoutDTO(pieceArray, session)
            return workoutDto
        } else {
            return nil
        }
    }
}

extension ItemsPresenter: ItemsPresenterDataDelegate {
    
    func setSessionTypeFromPicker(_ rowSelected: Int) {
        sessionViewFilter = sessionPickerValueArray[rowSelected]
        filterTitle = sessionPickerValueArray[rowSelected]
        viewDelegate?.reloadTable()
    }
    
    func deleteWorkout(_ section: Int) {
        let alert = UIAlertController(title: "Are you sure?", message: "Deleting this session can not be undone", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            
        }))
        alert.addAction( UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (action) in
            let workout = self?.workoutViewModelForSection(section)
           
            RepositoryFactory.shared.databaseRepo.delete(workout) 
        }))
 
        self.viewDelegate?.showAlert(alert)
    }
}

extension ItemsPresenter: ItemsPresenterViewDelegate {
    
    func setOrderingBy(_ orderType: OrderingByType) {
        self.orderByType = orderType
    }

    func setFilter(_ sessionType: SessionType?) {
        self.viewFilter = sessionType
        viewDelegate?.reloadTable()
    }

    func addWorkoutToDatabase(workout: WorkoutDTO) {
        RepositoryFactory.shared.databaseRepo.addWorkoutToDatabase(workout: workout)
        self.viewDelegate?.reloadTable()
    }
}

