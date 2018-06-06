//
//  HomeViewController.swift
//  erg
//
//  Created by Christie on 6/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var filterMenuButton: HomeButtonView!
    @IBOutlet weak var addErgButton: HomeButtonView!
    @IBOutlet weak var cameraButton: HomeButtonView!
    @IBOutlet weak var predictButton: HomeButtonView!
    @IBOutlet weak var settingsButton: HomeButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterMenuButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToFilter)))
        addErgButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToAddErg)))
        cameraButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToCamera)))
        predictButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToPredict)))
        settingsButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToSettings)))
    }
    
}

extension HomeViewController { // Menu Actions
    @objc
    func goToFilter() {
        self.performSegue(withIdentifier: "goToFilter", sender: self)
    }
    
    @objc
    func goToAddErg() {
        self.performSegue(withIdentifier: "goToAddErg", sender: self)
    }
    
    @objc
    func goToCamera() {
        self.performSegue(withIdentifier: "goToCamera", sender: self)
    }
    
    @objc
    func goToPredict() {
        self.performSegue(withIdentifier: "goToPredict", sender: self)
    }
    
    @objc
    func goToSettings() {
        self.performSegue(withIdentifier: "goToSettings", sender: self)
    }
}

class HomeButtonView: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        switch self.tag {
        case 0:
            setup("Filter", UIImage(imageLiteralResourceName: "icFilter"))
        case 1:
            setup("Add", UIImage(imageLiteralResourceName: "icAdd"))
        case 2:
            setup("Camera", UIImage(imageLiteralResourceName: "icCamera"))
        case 3:
            setup("Predict", UIImage(imageLiteralResourceName: "icComputer"))
        case 4:
            setup("Settings", UIImage(imageLiteralResourceName: "icSettings"))
        default:
            break
        }
    }
    
    func setup(_ title: String, _ image: UIImage) {
        imageView.image = image
        titleLabel.attributedText = title.uppercased().apply(font: UIFont.boldFont(14))
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
    }
}
