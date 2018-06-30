//
//  AddErgPresenter.swift
//  erg
//
//  Created by Christie on 22/03/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

protocol AddErgPresenterDelegate: InputCellDelegate {
    var viewDelegate: AddErgViewControllerDelegate? { get set }
    var sessionType: SessionType { get }
    var piece: PieceDTO { get }
        
    func saveSession()
}

class AddErgPresenter: NSObject, AddErgPresenterDelegate {
    
    weak var delegate: ItemsViewControllerDelegate?
    var viewDelegate: AddErgViewControllerDelegate?
    
    var sessionType: SessionType {
        return SessionType(rawValue: viewDelegate?.segmentIndex ?? 0) ?? .distance
    }
    
    init(itemsControllerDelegate: ItemsViewControllerDelegate) {
       piece = PieceDTO(rowId: 0)
        super.init()
        self.delegate = itemsControllerDelegate
    }

    var piece: PieceDTO

    func saveSession() {
        var newSession: SessionDTO?
        
        if self.sessionType == .distance {
            newSession = SessionDTO(id: nil, title: self.piece.distance, sessionType: self.sessionType, date: Date())
            
        } else {
            newSession = SessionDTO(id: nil, title: piece.time, sessionType: self.sessionType, date: Date())

        }
        
        if let newSession = newSession {
            let workout = WorkoutDTO([piece], newSession)
            DatabaseRepo.shared.addWorkoutToDatabase(workout: workout)
            
        } else {
            print("Errror")
        }
        viewDelegate?.dismissView()
    }
    
    func updatePiece(pieceDTO: PieceDTO) {
        self.piece = pieceDTO
    }
    
}
