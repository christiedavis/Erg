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

        if indexPath.item == 0 {
            var cell: HeaderCell! = tableView.dequeueReusableCell(withIdentifier: HeaderCell.cellName) as? HeaderCell
            if cell == nil {
                tableView.register(UINib(nibName: HeaderCell.cellName, bundle: nil), forCellReuseIdentifier: HeaderCell.cellName)
                cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.cellName) as? HeaderCell
            }
            
            let workout = presenter?.workoutViewModelForSection(indexPath.section)
            // TODO: this is nt working
            cell.setUpAsSessionCell(workout: workout, filterType: presenter?.filter, row: indexPath.row)
            return cell
            
        } else {
            
            var cell: SessionCell! = tableView.dequeueReusableCell(withIdentifier: HeaderCell.cellName) as? SessionCell
            if cell == nil {
                tableView.register(UINib(nibName: SessionCell.cellName, bundle: nil), forCellReuseIdentifier: SessionCell.cellName)
                cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.cellName) as? SessionCell
            }
            
//            let workout = presenter?.workoutViewModelForSection(indexPath.row)
//            cell.setUpAsSessionCell(workout: workout)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let workout = presenter?.workoutViewModelForSection(indexPath.row)
            DatabaseRepo.shared.delete(workout)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ItemsDatasource: UITableViewDelegate {
    
}

extension ItemsDatasource: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return presenter?.sessionPickerValueArray.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(attributedString: (presenter?.sessionPickerValueArray[row] ?? "").apply(font: UIFont.regularFont(16)))
    attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // The parameter named row and component represents what was selected.
        presenter?.setSessionTypeFromPicker(row)
    }
}
