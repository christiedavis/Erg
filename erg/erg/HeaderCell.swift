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

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
       
    }
    
    func setUpAsSessionCell(workout: WorkoutDTO?) {
        
        if workout?.session.sessionType == .time {
            if let first = workout?.pieceArray.first {
                
                subtitleLabel?.attributedText = "\(first.distance) m".apply(font: UIFont.regularFont(16))
                titleLabel?.attributedText = "\(first.time) mins".apply(font: UIFont.boldFont(18))
            }

            
        } else if workout?.session.sessionType == .distance {
            if let first = workout?.pieceArray.first {
                
                titleLabel?.attributedText = "\(first.distance) m".apply(font: UIFont.boldFont(18))
                subtitleLabel?.attributedText = "\(first.time) mins".apply(font: UIFont.regularFont(16))
            }
        }

        rightLabel .attributedText = workout?.session.date?.asFullDate()?.apply(font: UIFont.regularFont(14))
        layoutCell()
    }
    
    private func layoutCell() {
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
}
