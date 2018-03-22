//
//  HeaderCell.swift
//  erg
//
//  Created by Christie on 12/10/17.
//  Copyright © 2017 star. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    static var reuseIdentifier: String! { return "HeaderCell" }
    static var nibName: String! { return "HeaderCell" }
    static var cellName: String = "HeaderCell"

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var leftLabel: UILabel!
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
//        rightLabel.attributedText = "Time".apply(font: .boldFont(size: 16))
//        leftLabel.attributedText = "Distance".apply(font: .boldFont(size: 16))
    }
    
    func setUpAsSessionCell(workout: WorkoutDTO?) {
        if let first = workout?.pieceArray.first, let distance = first.distance, let time = first.time {
            
            rightLabel?.attributedText = "\(distance) km".apply(font: UIFont.regularFont(12))
            leftLabel?.attributedText = "\(time) mins".apply(font: UIFont.regularFont(12))
        }

        dateLabel.attributedText = workout?.session.date.asFullDate()?.apply(font: UIFont.regularFont(12))
    
    }
}
