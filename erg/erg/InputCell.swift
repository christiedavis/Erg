//
//  InputCell.swift
//  erg
//
//  Created by Christie on 13/05/17.
//  Copyright © 2017 star. All rights reserved.
//

import UIKit

enum InputType {
   case Time,
        Distance,
        Split,
        Rate,
        HeartRate
}

class InputCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var unitLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ inputType: InputType) {
        switch inputType {
            case .Time:
            titleLabel.text = "Total time"
            unitLabel.text = "m"
            
            case .Distance:
            titleLabel.text = "Distance"
            unitLabel.text = "m"
            
            case .Split:
            titleLabel.text = "Split"
            unitLabel.text = "m/s"
            
            case .Rate:
            titleLabel.text = "Rate"
            unitLabel.text = "spm"
            
            case .HeartRate:
            titleLabel.text = "Heart Rate"
            unitLabel.text = "Bpm"
        }
    }
}
