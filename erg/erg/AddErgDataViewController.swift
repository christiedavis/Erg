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

class AddErgDataViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var noPiecesLabel: UILabel!
    @IBOutlet weak var noPiecesStepper: UIStepper!
    
    var sessionType: SessionType {
        return SessionType(rawValue: segmentView.selectedSegmentIndex) ?? .distance
    }
    
    var noPieces: Int = 0 {
        didSet {
            if noPieces < 0 {
                noPieces = 0
            }
            noPiecesLabel.text = "\(noPieces)"
        }
    }
    
    weak var delegate: ItemsViewControllerDelegate?
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveSession)), animated: true)
        
        tableView.isHidden = true
    }
    
    @IBAction func segmentTapped(_ sender: Any) {
        reloadTable()
    }
    
    @IBAction func stepperTapped(_ sender: Any) {
        noPieces = Int(noPiecesStepper.value)
        reloadTable()
    }
    
    func reloadTable() {
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    @objc
    func saveSession() {
        // todo actually add item
        
        let pieces = PieceDTO(distance: 23, time: 32, rate: 23)
        let newSession = SessionDTO(title: "hello", type: 32, distance: 23, time: 232, rate: 23, date: Date(), pieces: [ 0 : pieces])
        
        delegate?.addItemToView(session: newSession)
//                    self.ref.child("users").child(self.user.uid).child("items").childByAutoId().child("title").setValue(userInput)

        self.navigationController?.popViewController(animated: true)
        
    }
}

extension AddErgDataViewController: UITableViewDataSource, UITableViewDelegate {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return noPieces
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var cell: InputCell! = tableView.dequeueReusableCell(withIdentifier: InputCell.cellName) as? InputCell
        if cell == nil {
            tableView.register(UINib(nibName: InputCell.cellName, bundle: nil), forCellReuseIdentifier: InputCell.cellName)
            cell = tableView.dequeueReusableCell(withIdentifier: InputCell.cellName) as? InputCell
        }
        
        if indexPath.item == 0 {
            cell.setupheader(indexPath.section)
        } else if indexPath.item == 1 {
            if sessionType == .distance {
                cell.setup(.distance)
            } else {
                cell.setup(.time)
            }
        } else if indexPath.item == 2 {
            if sessionType == .distance {
                cell.setup(.time)
            } else {
                cell.setup(.distance)
            }
        } else if indexPath.item == 3 {
            cell.setup(.rate)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.row == 0 {
            return 40
        }
        return 60
    }
}
