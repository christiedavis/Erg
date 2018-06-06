//
//  HomeViewController.swift
//  erg
//
//  Created by Christie on 6/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
