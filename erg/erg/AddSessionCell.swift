//
//  AddSessionCell.swift
//  erg
//
//  Created by Christie on 13/05/17.
//  Copyright © 2017 star. All rights reserved.
//

import UIKit

enum InputType {
   case time
   case distance
}

protocol InputCellDelegate: class {
    func updatePiece(pieceDTO: PieceDTO)
}

class AddSessionCell: UITableViewCell {

    @IBOutlet weak var primaryLabel: UILabel?
    @IBOutlet weak var primaryInput: UITextField?

    @IBOutlet weak var secondaryLabel: UILabel?
    @IBOutlet weak var secondaryInput: UITextField?
    
    @IBOutlet weak var rateLabel: UILabel?
    @IBOutlet weak var rateInput: UITextField?
    
    @IBOutlet weak var splitInput: UITextField!
    
    @IBOutlet weak var topDivider: UIView!
    @IBOutlet weak var bottomDivider: UIView!
    
    var inputType: InputType?
    var pieceDto: PieceDTO? {
        didSet {
            cellDelegate?.updatePiece(pieceDTO: self.pieceDto!)
        }
    }
    static var cellName: String = "AddSessionCell"
    
    weak var cellDelegate: InputCellDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(_ inputType: InputType, _ piece: PieceDTO) {
        self.pieceDto = piece
        self.inputType = inputType
    
        rateLabel?.text = "Rate"
        
        switch inputType {
            case .time:
                primaryLabel?.text = "Time:"
                
                secondaryLabel?.text = "Distance:"
                
            case .distance:
                primaryLabel?.text = "Distance:"
                
                secondaryLabel?.text = "Time:"
        }
    }

    @IBAction func editingDidChange(_ sender: Any) {
        if let inputType = self.inputType, let textInput = sender as? UITextField {
            
            if textInput.tag == Constants.InputTags.rateInput {
                pieceDto?.rate = rateInput?.text ?? ""
            }
            
            if textInput.tag == Constants.InputTags.aveSplitInput {
                pieceDto?.aveSplit = splitInput.text ?? ""
            }
            
            switch inputType {
            case .time:
                if textInput.tag == Constants.InputTags.primaryInput {
                    pieceDto?.time = primaryInput?.text ?? ""
                } else {
                    pieceDto?.distance = secondaryInput?.text ?? ""
                }
                
            case .distance:
                if textInput.tag == Constants.InputTags.primaryInput {
                    pieceDto?.distance = primaryInput?.text ?? ""
                } else {
                    pieceDto?.time = secondaryInput?.text ?? ""
                    
                }
            }
        }
    }
    
    @IBAction func editingDidEnd(_ sender: Any) {
       
    }
}
