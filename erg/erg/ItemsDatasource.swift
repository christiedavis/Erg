//
//  ItemsDatasource.swift
//  erg
//
//  Created by Christie Davis on 12/02/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

class ItemsDatasource: NSObject {
    var presenter: ItemsPresenterDataDelegate?
    
    override init() {
        super.init()
    }
    
    init(_ presenter: ItemsPresenterDataDelegate) {
        self.presenter = presenter
    }
}

extension ItemsDatasource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let presenter = presenter else {
            return 0
        }
        
        return presenter.numberOfSessions
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            return 0
        }
        let numRows = presenter.rowsForSession(section)
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SessionCell! = tableView.dequeueReusableCell(withIdentifier: SessionCell.cellName) as? SessionCell
        if cell == nil {
            tableView.register(UINib(nibName: SessionCell.cellName, bundle: nil), forCellReuseIdentifier: SessionCell.cellName)
            cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.cellName) as? SessionCell
        }
        
        let piece = presenter?.sessionViewModelForRow(indexPath.row)
        cell.textLabel?.text = "\(piece?.distance) + \(piece?.time)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            presenter.delete()
//            let item = items[indexPath.row]
//            item.ref.removeValue()
        }
    }
}

extension ItemsDatasource: UITableViewDelegate {
    
}

extension ItemsDatasource: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //sessionPickerValueArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter?.sessionPickerValueArray.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return presenter?.sessionPickerValueArray[row] ?? "Error"
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // The parameter named row and component represents what was selected.
        presenter?.setSessionTypeFromPicker(row) //presenter?.sessionPickerValueArray[row] ?? "filter")
    }
}

