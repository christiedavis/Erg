//
//  BaseViewController.swift
//  erg
//
//  Created by Christie on 22/03/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

internal class BaseViewController: UIViewController {

    @IBOutlet weak var loadingView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func showLoading() {
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    internal func dismissLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }
}
