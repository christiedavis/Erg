//
//  AddErgPresenter.swift
//  erg
//
//  Created by Christie on 22/03/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

protocol AddErgPresenterDelegate: class {
    var viewDelegate: AddErgViewControllerDelegate? { get set }
    var datasource: AddErgDataSource { get }
    
    var noPieces: Int { get }
    func addPiece()
    func removePiece()
    
    func saveSession()
}

protocol AddErgPresenterDataDelegate: class {
    var noPieces: Int { get }
    var sessionType: SessionType { get }
    
    func pieceForRow(_ row: Int) -> PieceDTO
}

class AddErgPresenter: NSObject {
    
    weak var delegate: ItemsViewControllerDelegate?
    var viewDelegate: AddErgViewControllerDelegate?
    var datasource: AddErgDataSource
    
    var sessionType: SessionType {
        return SessionType(rawValue: viewDelegate?.segmentIndex ?? 0) ?? .distance
    }
    
    init(itemsControllerDelegate: ItemsViewControllerDelegate) {
        datasource = AddErgDataSource() // I hate this
        super.init()
        self.delegate = itemsControllerDelegate
        addPiece()
        datasource = AddErgDataSource(self)
    }
    
    private var pieces: [Int :PieceDTO] = [:]
    var noPieces: Int {
        return pieces.count
    }
}

extension AddErgPresenter: AddErgPresenterDataDelegate {
    func pieceForRow(_ row: Int) -> PieceDTO {
        if let piece = pieces[row] {
            return piece
        } else {
            let piece = PieceDTO(rowId: pieces.count)
            pieces[pieces.count] = piece
            return piece
        }
    }
}

extension AddErgPresenter: AddErgPresenterDelegate {
    func addPiece() {
        pieces[pieces.count] = PieceDTO(rowId: pieces.count)
        viewDelegate?.reloadTable()
    }
    
    func removePiece() {
        pieces.removeValue(forKey: pieces.count - 1)
        viewDelegate?.reloadTable()
    }
    
    func saveSession() {
        
        let pieceArray = self.pieces.map { (key: Int, value: PieceDTO) in
            return value
        }
        
        let newSession = SessionDTO(id: nil, title: "hello", sessionType: self.sessionType, date: Date())
        let workout = WorkoutDTO(pieceArray, newSession)

        delegate?.addWorkoutToView(workout: workout)
        viewDelegate?.dismissView()
    }
}

extension AddErgPresenter: InputCellDelegate {
    func updatePiece(pieceDTO: PieceDTO) {
        pieces[pieceDTO.rowId] = pieceDTO
    }
}
