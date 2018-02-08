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
    
    @IBOutlet weak var topDivider: UIView!
    @IBOutlet weak var bottomDivider: UIView!
    
    @IBOutlet var inputBottomConstraint: NSLayoutConstraint!
    
    static var cellName: String = "InputCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // not called
    }
    
    private func setup() {
        bottomDivider.backgroundColor = UIColor.gray
        topDivider.backgroundColor = .gray
        
        topDivider.isHidden = true
        bottomDivider.isHidden = true
        
        inputBottomConstraint.constant = 15
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        inputField?.isHidden = false

    }
    
    func setupheader(_ pieceNo: Int) {
        setup()
        inputField?.isHidden = true
        titleLabel?.text = "Piece \(pieceNo + 1)"
        
        topDivider.isHidden = false
        bottomDivider.isHidden = false
        
        inputBottomConstraint.constant = 10
        
        
    }
    
    func setup(_ inputType: InputType) {
        setup()
       
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
