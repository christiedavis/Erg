//
//  AddErgDataSource.swift
//  erg
//
//  Created by Christie on 22/03/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

class AddErgDataSource: NSObject {
    var presenter: (AddErgPresenterDataDelegate & InputCellDelegate)?
    
    override init() {
        super.init()
    }
    
    init(_ presenter: AddErgPresenterDataDelegate & InputCellDelegate) {
        self.presenter = presenter
    }
}
extension AddErgDataSource: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let presenter = self.presenter else {
            return 0
        }
        return presenter.noPieces
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let presenter = self.presenter else {
            return UITableViewCell()
        }
        
        var cell: AddSessionCell! = tableView.dequeueReusableCell(withIdentifier: AddSessionCell.cellName) as? AddSessionCell
        if cell == nil {
            tableView.register(UINib(nibName: AddSessionCell.cellName, bundle: nil), forCellReuseIdentifier: AddSessionCell.cellName)
            cell = tableView.dequeueReusableCell(withIdentifier: AddSessionCell.cellName) as? AddSessionCell
        }
        
        if indexPath.item == 0 {
            if presenter.sessionType == .distance {
                cell.setup(.distance, presenter.pieceForRow(indexPath.row))
            } else {
                cell.setup(.time, presenter.pieceForRow(indexPath.row))
            }
        } 
        cell.cellDelegate = self.presenter
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}
