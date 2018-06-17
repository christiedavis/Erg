//
//  UIExtensions.swift
//  erg
//
//  Created by Christie on 17/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

extension UIButton {
    
    func addBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.borderGrey.cgColor
    }
}

extension UITextField {
    func styleText(placeHolderText: String) {
        self.font = UIFont.systemFont(ofSize: 20.0)
        self.attributedPlaceholder = placeHolderText.apply(font: UIFont.systemFont(ofSize: 20.0), color: UIColor.borderGrey)
    }
    
    func addBorder() {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.borderGrey.cgColor
    }
}
