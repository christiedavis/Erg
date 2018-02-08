//
//  InputCell.swift
//  erg
//
//  Created by Christie on 13/05/17.
//  Copyright © 2017 star. All rights reserved.
//

import UIKit

enum InputType {
   case time,
        distance,
        split,
        rate,
        heartRate,
        header
}

class InputCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var inputField: UITextField?
    @IBOutlet weak var unitLabel: UILabel?
    
    static var cellName: String = "InputCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setupheader(_ pieceNo: Int) {
        
    }
    
    func setup(_ inputType: InputType) {
        self.awakeFromNib()
        
        switch inputType {
            case .time:
            titleLabel?.text = "Total time"
            unitLabel?.text = "m"
            
            case .distance:
            titleLabel?.text = "Distance"
            unitLabel?.text = "m"
            
            case .split:
            titleLabel?.text = "Split"
            unitLabel?.text = "m/s"
            
            case .rate:
            titleLabel?.text = "Rate"
            unitLabel?.text = "spm"
            
            case .heartRate:
            titleLabel?.text = "Heart Rate"
            unitLabel?.text = "Bpm"
            
        case .header:
            titleLabel?.text = "tile"
        }
    }
}
