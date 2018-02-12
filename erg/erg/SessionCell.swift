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
    
    static var reuseIdentifier: String! { return "SessionCell" }
    static var nibName: String! { return "SessionCell" }
    
    func setupWithErgSession(_ ergSession: ErgSessionModel) {
        timeLabel?.attributedText = (ergSession.time ?? "error").apply(font: UIFont.regularFont(size: 12))
        distanceLabel?.attributedText = (ergSession.distance ?? "error").apply(font: UIFont.regularFont(size: 12))
    }
}
