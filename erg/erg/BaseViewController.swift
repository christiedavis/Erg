//
//  BaseViewController.swift
//  erg
//
//  Created by Christie on 22/03/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

internal class BaseViewController: UIViewController {

    @IBOutlet weak var loadingView: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    internal func showLoading() {
        loadingView?.isHidden = false
        loadingView?.alpha = 0
        loadingView?.startAnimating()

        UIView.animate(withDuration: 0.1) {
            self.loadingView?.alpha = 1
        }
    }
    
    internal func dismissLoading() {
        UIView.animate(withDuration: 0.1) {
            self.loadingView?.alpha = 0
        }
        
        loadingView?.stopAnimating()
        loadingView?.isHidden = true
    }
    
    func showAlert(_ alertVc: UIAlertController) {
        self.show(alertVc, sender: self)
    }
}
