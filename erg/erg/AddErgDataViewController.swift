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
    
    func setButtonValid(_ valid: Bool)
    func reloadTable()
    func dismissView()
}

class AddErgDataViewController: UIViewController {

//    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var noPiecesLabel: UILabel!
    @IBOutlet weak var noPiecesStepper: UIStepper!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet var addSessionView: AddWorkoutView!
    
    weak var dissmissableCompletetionView: Dismissable?
    
    var presenter: AddErgPresenterDelegate?
    
    var segmentIndex: Int {
        return self.segmentView.selectedSegmentIndex
    }
    
    override func viewDidLoad() {
        
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSession)), animated: true)
        
        self.setButtonValid(false)
        addSessionView.cellDelegate = presenter
        submitButton.layer.cornerRadius = 5
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        if let presenter = presenter {
            if presenter.sessionType == .distance {
                addSessionView.setup(.distance, presenter.piece)
            } else {
                addSessionView.setup(.time, presenter.piece)
            }
        }
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        reloadTable()
    }
    
    @IBAction func stepperTapped(_ sender: Any) {
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
        dissmissableCompletetionView?.shouldDismissOnAppear = true
        dismissView()
    }
    
    internal func dismissView() {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func dismissKeyboard() {
        addSessionView.dismissKeyboard()
    }
}

extension AddErgDataViewController: AddErgViewControllerDelegate {
    
    func reloadTable() {
        if let presenter = presenter {

            if presenter.sessionType == .distance {
                self.addSessionView.setup(.distance, presenter.piece)
            } else {
                self.addSessionView.setup(.time, presenter.piece)
            }
        }
    }
    
    func setButtonValid(_ valid: Bool) {
        self.submitButton.isEnabled = valid
        if valid {
            self.submitButton.alpha = 1.0
        } else {
            self.submitButton.alpha = 0.5
        }
    }
}
