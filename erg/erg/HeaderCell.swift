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
       
    }
    
    func setUpAsSessionCell(workout: WorkoutDTO?) {
        if let first = workout?.pieceArray.first {
            
            rightLabel?.attributedText = "\(first.distance) km".apply(font: UIFont.regularFont(16))
            leftLabel?.attributedText = "\(first.time) mins".apply(font: UIFont.regularFont(16))
        }

        dateLabel.attributedText = workout?.session.date.asFullDate()?.apply(font: UIFont.boldFont(16))
        layoutCell()
    }
    
    private func layoutCell() {
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
}
