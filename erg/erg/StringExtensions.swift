//
//  StringExtensions.swift
//  erg
//
//  Created by Christie on 22/03/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

extension String {
    
    func apply(font: UIFont, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : color])
    }
    
    func apply(font: UIFont) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font : font, NSAttributedString.Key.foregroundColor : UIColor.textNavy])
    }
    
    func stringAtIndex(_ index: Int) -> String {
        
        let newIndex = self.index(startIndex, offsetBy: index)
        let stringToRetrun = String(self[newIndex])
        return stringToRetrun
    }
}
