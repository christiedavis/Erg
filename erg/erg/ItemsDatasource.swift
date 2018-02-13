//
//  ItemsDatasource.swift
//  erg
//
//  Created by Christie Davis on 12/02/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

class ItemsDatasource: NSObject {
    var items: [String] = ["hi", "hello"]
    
    var sessionPickerValueArray: [String] = ["No filter"]
    var sessionFilter: String = "No Filter"
    
    override init() {
        super.init()
        
        
    }
}

extension ItemsDatasource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SessionCell! = tableView.dequeueReusableCell(withIdentifier: SessionCell.cellName) as? SessionCell
        if cell == nil {
            tableView.register(UINib(nibName: SessionCell.cellName, bundle: nil), forCellReuseIdentifier: SessionCell.cellName)
            cell = tableView.dequeueReusableCell(withIdentifier: SessionCell.cellName) as? SessionCell
        }
        
        let item = items[indexPath.row]
//        cell.textLabel?.text = item.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
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
        return sessionPickerValueArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sessionPickerValueArray[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // The parameter named row and component represents what was selected.
        sessionFilter = sessionPickerValueArray[row]
    }
}

