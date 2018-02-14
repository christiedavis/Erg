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

    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var leftLabel: UILabel!
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        
//        rightLabel.attributedText = "Time".apply(font: .boldFont(size: 16))
//        leftLabel.attributedText = "Distance".apply(font: .boldFont(size: 16))

    }
}
