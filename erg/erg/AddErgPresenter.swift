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
        pieces.append(PieceDTO(rowId: 0))
        datasource = AddErgDataSource(self)
    }
    
    var pieces: [PieceDTO] = []
    var noPieces: Int {
        return pieces.count
//        didSet {
//            if noPieces < 0 {
//                noPieces = 0
//            }
//            self.viewDelegate?.reloadTable()
//        }
    }
}

extension AddErgPresenter: AddErgPresenterDataDelegate {
    func pieceForRow(_ row: Int) -> PieceDTO {
        return pieces[row - 1]
    }
}

extension AddErgPresenter: AddErgPresenterDelegate {
    func addPiece() {
        pieces.append(PieceDTO(rowId: pieces.count))
    }
    func removePiece() {
        pieces.removeLast()
    }
}

extension AddErgPresenter: InputCellDelegate {
    
}
