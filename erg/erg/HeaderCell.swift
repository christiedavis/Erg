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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitle: UILabel!
    @IBOutlet var splitLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    
    var row: Int = 0

    
    func setUpAsSessionCell(workout: WorkoutDTO?, filterType: SessionType?, row: Int) {
        self.row = row
        
        if let first = workout?.pieceArray.first {

            self.dateLabel.text = workout?.session.date?.asFullDate()//.apply(font: UIFont.regularFont(14))
            self.splitLabel.text = first.aveSplit
            self.rateLabel.text = first.rate

            if let filterType = filterType {
                if filterType == .distance {
                    titleLabel?.text = "\(first.distance) m"//.apply(font: UIFont.regularFont(16))
                    subtitle.text = "\(first.time) mins"
                    
                } else {
                    // time
                    titleLabel?.text = "\(first.time) mins" //.apply(font: UIFont.regularFont(16))
                    subtitle?.text = "\(first.distance) m" //.apply(font: UIFont.regularFont(16))
                }
                
            } else {
    //            default layout
                subtitle?.text = "\(first.distance) m" //.apply(font: UIFont.regularFont(16))
                titleLabel?.text = "\(first.time) mins"//.apply(font: UIFont.regularFont(16))
            }
        }
        layoutCell()
    }
    
    private func layoutCell() {
        if row % 2 == 0 {
        
            backgroundColor = UIColor(red: 76.0/255.0, green: 175.0/255.0, blue: 241.0/255/0, alpha: 0.1)
        } else {
            backgroundColor = UIColor(red: 250.0/255.0, green: 251.0/255.0, blue: 252.0/255/0, alpha: 1.0)
            
        }
    }
}
