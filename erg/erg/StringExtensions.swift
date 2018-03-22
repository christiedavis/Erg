//
//  StringExtensions.swift
//  erg
//
//  Created by Christie on 22/03/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

extension String {
    func apply(font: UIFont) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedStringKey.font : font])
    }
}
