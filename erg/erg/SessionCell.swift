//
//  SessionCell.swift
//  erg
//
//  Created by Christie on 11/10/17.
//  Copyright © 2017 star. All rights reserved.
//

import UIKit

class SessionCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel?
    @IBOutlet var distanceLabel: UILabel?
    
    static var cellName: String = "SessionCell"

    static var reuseIdentifier: String! { return "SessionCell" }
    static var nibName: String! { return "SessionCell" }
    
    func setUpAsSessionCell(sessionDto: SessionDTO) {
        timeLabel?.text = sessionDto.title
        distanceLabel?.text  = "\(sessionDto.date)"
    }
}
