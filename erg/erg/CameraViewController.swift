//
//  CameraViewController.swift
//  
//
//  Created by Christie on 16/06/18.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

}
