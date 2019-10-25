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

class BaseView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        fromNib()
    }
    
    var viewSize: CGSize {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let targetSize = CGSize(width: UIScreen.main.bounds.size.width, height: 600)
        
        self.setNeedsUpdateConstraints()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.updateConstraints()
        
        let size = self.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        
        return CGSize(width: UIScreen.main.bounds.size.width, height: size.height)
    }
}

extension UIView {
    
    func fromNib() {
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? UIView else {
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: [ "view": view ]))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: [ "view": view ]))
        self.addConstraints(constraints)
        
        view.frame = self.bounds
    }

}
