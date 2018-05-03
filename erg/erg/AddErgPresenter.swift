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
}

protocol AddErgPresenterDataDelegate: class {
    var noPieces: Int { get }
    var sessionType: SessionType { get }
    
    func pieceForRow(_ row: Int) -> PieceDTO
}

class AddErgPresenter: NSObject {

    var viewDelegate: AddErgViewControllerDelegate?
    var datasource: AddErgDataSource
    
    var sessionType: SessionType {
        return SessionType(rawValue: viewDelegate?.segmentIndex ?? 0) ?? .distance
    }
    
    override init() {
        datasource = AddErgDataSource()
        super.init()
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
}

extension AddErgPresenter: InputCellDelegate {
    func updatePiece(pieceDTO: PieceDTO) {
        pieces[pieceDTO.rowId] = pieceDTO
    }
}
