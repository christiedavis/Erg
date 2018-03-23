//
//  AddErgDataSource.swift
//  erg
//
//  Created by Christie on 22/03/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

class AddErgDataSource: NSObject {
    var presenter: AddErgPresenterDataDelegate?
    
    override init() {
        super.init()
    }
    
    init(_ presenter: AddErgPresenterDataDelegate) {
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
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let presenter = self.presenter else {
            return UITableViewCell()
        }
        
        var cell: InputCell! = tableView.dequeueReusableCell(withIdentifier: InputCell.cellName) as? InputCell
        if cell == nil {
            tableView.register(UINib(nibName: InputCell.cellName, bundle: nil), forCellReuseIdentifier: InputCell.cellName)
            cell = tableView.dequeueReusableCell(withIdentifier: InputCell.cellName) as? InputCell
        }
        
        if indexPath.item == 0 {
            cell.setupheader(indexPath.section)
        } else if indexPath.item == 1 {
            if presenter.sessionType == .distance {
                cell.setup(.distance)
            } else {
                cell.setup(.time)
            }
        } else if indexPath.item == 2 {
            if presenter.sessionType == .distance {
                cell.setup(.time)
            } else {
                cell.setup(.distance)
            }
        } else if indexPath.item == 3 {
            cell.setup(.rate)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 40
        }
        return 60
    }
}
//
//extension ItemsDatasource: UIPickerViewDataSource, UIPickerViewDelegate {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1 //sessionPickerValueArray.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return presenter?.sessionPickerValueArray.count ?? 0
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return presenter?.sessionPickerValueArray[row] ?? "Error"
//    }
//    
//    // Catpure the picker view selection
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        // The parameter named row and component represents what was selected.
//        presenter?.setSessionTypeFromPicker(row) //presenter?.sessionPickerValueArray[row] ?? "filter")
//    }
//}
//
