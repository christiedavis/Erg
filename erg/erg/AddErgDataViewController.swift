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
}

class AddErgDataViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var noPiecesLabel: UILabel!
    @IBOutlet weak var noPiecesStepper: UIStepper!
    
    var presenter: AddErgPresenterDelegate?
    weak var delegate: ItemsViewControllerDelegate?
    
    var segmentIndex: Int {
        return self.segmentView.selectedSegmentIndex
    }
    
    override func viewDidLoad() {
        tableView.dataSource = presenter!.datasource
        tableView.delegate = presenter!.datasource
        
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSession)), animated: true)
        
        tableView.isHidden = true
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        reloadTable()
    }
    
    @IBAction func stepperTapped(_ sender: Any) {
        presenter?.noPieces = Int(noPiecesStepper.value)
    }
    

    
    @objc
    func saveSession() {
        // todo actually add item
        let pieces0 = PieceDTO(distance: 23, time: 32, rate: 23)
        let pieces1 = PieceDTO(distance: 23, time: 32, rate: 23)
        let pieces2 = PieceDTO(distance: 23, time: 32, rate: 23)
        let pieces3 = PieceDTO(distance: 23, time: 32, rate: 23)

        let newSession = SessionDTO(id: nil, title: "hello", sessionType: .time, date: Date())
        let workout = WorkoutDTO([pieces0, pieces1, pieces2, pieces3], newSession)
        
        delegate?.addWorkoutToView(workout: workout)
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddErgDataViewController: AddErgViewControllerDelegate {
    
    func reloadTable() {
        tableView.isHidden = false
        tableView.reloadData()
        noPiecesLabel.text = "\(tableView.numberOfSections)"
    }
}
