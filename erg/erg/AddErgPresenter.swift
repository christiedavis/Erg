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
    
    var noPieces: Int { get set }
}

protocol AddErgPresenterDataDelegate: class {
    var noPieces: Int { get set }
    var sessionType: SessionType { get }
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
        datasource = AddErgDataSource(self)
    }
    
    var noPieces: Int = 0 {
        didSet {
            if noPieces < 0 {
                noPieces = 0
            }
            self.viewDelegate?.reloadTable()
        }
    }
}

extension AddErgPresenter: AddErgPresenterDataDelegate {
 
}

extension AddErgPresenter: AddErgPresenterDelegate {
    
}

extension AddErgPresenter: InputCellDelegate {
    
}
