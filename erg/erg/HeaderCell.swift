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
    
    func setUpAsSessionCell(sessionDto: SessionDTO?) {
        if let first = sessionDto?.pieces.first {
            rightLabel?.text = "\(first.distance)"
            leftLabel?.text  = "\(first.time)"
        }
        
        dateLabel.text = "\(sessionDto?.date ?? Date())"
        
//    func setupWithErgSession(_ ergSession: ErgSe“ssionModel) {
//        timeLabel?.attributedText = (ergSession.time ?? "error").apply(font: UIFont.regularFont(size: 12))
//        distanceLabel?.attributedText = (ergSess”ion.distance ?? "error").apply(font: UIFont.regularFont(size: 12))
    }
}
