//
//  AddErgDataViewController.swift
//  erg
//
//  Created by Christie on 13/05/17.
//  Copyright © 2017 star. All rights reserved.
//

import UIKit

enum SessionType: Int {
    case distance
    case time
}

protocol AddErgViewControllerDelegate: class {
    var segmentIndex: Int { get }
    var presenter: AddErgPresenterDelegate? { get set }
    
    func reloadTable()
    func dismissView()
}

class AddErgDataViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var noPiecesLabel: UILabel!
    @IBOutlet weak var noPiecesStepper: UIStepper!
    @IBOutlet weak var submitButton: UIButton!
    
    var presenter: AddErgPresenterDelegate?
    
    var segmentIndex: Int {
        return self.segmentView.selectedSegmentIndex
    }
    
    override func viewDidLoad() {
        tableView.dataSource = presenter!.datasource
        tableView.delegate = presenter!.datasource
        noPiecesStepper.tag = Int(noPiecesStepper.value)
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSession)), animated: true)
        
        noPiecesLabel.text = "\(tableView.numberOfSections)"

        submitButton.layer.cornerRadius = 5
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        reloadTable()
    }
    
    @IBAction func stepperTapped(_ sender: Any) {
        if noPiecesStepper.tag > Int(noPiecesStepper.value) {
            // they've tapped -
            presenter?.removePiece()
        } else {
            presenter?.addPiece()
        }
        noPiecesStepper.tag = Int(noPiecesStepper.value)
    }
    
    @objc
    func saveSession() {
        presenter?.saveSession()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismissView()
    }

    @IBAction func submittButtonTapped(_ sender: Any) {
        presenter?.saveSession()
        dismissView()
    }
    
    internal func dismissView() {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func dismissKeyboard() {
        tableView.visibleCells.forEach { (cell) in
            if let sessionCell = cell as? AddSessionCell {
                sessionCell.dismissKeyboard()
            }
        }
    }
}

extension AddErgDataViewController: AddErgViewControllerDelegate {
    
    func reloadTable() {
        tableView.isHidden = false
        tableView.reloadData()
        noPiecesLabel.text = "\(tableView.numberOfSections)"
    }
}
