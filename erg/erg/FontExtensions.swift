//
//  FontExtensiuons.swift
//  erg
//
//  Created by Christie Davis on 9/02/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

let curlyFontName: String = "Sofia-Regular"
let boldFontName: String = "Lora-Bold"
let regularFontName: String = "Lora-Regular"
let italicFontName: String = "Lora-Italic"

extension UIFont {
    
    static func curlyFont(_ size: Int = 25) -> UIFont {
        return UIFont(name: curlyFontName, size: CGFloat(size))!
    }
    
    static func boldFont(_ size: Int = 12) -> UIFont {
        return UIFont(name: boldFontName, size: CGFloat(size))!
    }
    
    static func regularFont(_ size: Int = 12) -> UIFont {
        return UIFont(name: regularFontName, size: CGFloat(size))!
    }
    
    static func curlyFontLarge(_ size: Int = 12) -> UIFont {
        return UIFont(name: curlyFontName, size: CGFloat(size))!
    }
}
