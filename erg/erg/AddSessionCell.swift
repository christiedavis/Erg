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
    @IBOutlet var primaryUnits: UILabel!
    
    @IBOutlet weak var secondaryLabel: UILabel?
    @IBOutlet weak var secondaryInput: UITextField?
    @IBOutlet var secondaryUnits: UILabel!
    
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
    
    func setup() {
        rateInput?.delegate = self
        
    }
    
    func setup(_ inputType: InputType, _ piece: PieceDTO) {
        self.pieceDto = piece
        self.inputType = inputType
    
        rateLabel?.text = "Rate"
        
        switch inputType {
            case .time:
                primaryLabel?.text = "Time:"
                primaryUnits.text = "mins"
                secondaryLabel?.text = "Distance:"
                secondaryUnits.text = "meters"
            case .distance:
                primaryLabel?.text = "Distance:"
                primaryUnits.text = "meters"
                secondaryLabel?.text = "Time:"
                secondaryUnits.text = "mins"
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

extension AddSessionCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
    return true
    }
}
//        let digits = NSCharacterSet.decimalDigits
//        let punctuation = NSCharacterSet.punctuationCharacters
//
//        let textFieldValue: NSString? = textField.text as NSString?
//        if let newText = textFieldValue?.replacingCharacters(in: range, with: string) {
//            if let unicodeScalar = text.unicodeScalars.first {
//                if letters.contains(unicodeScalar) {
//                    log.debug("line number")
//                    return false
//
//                } else if digits.contains(unicodeScalar) {
//                    log.debug("work order number")
//                    return true
//                }
//            }
//            return nil
//            let letters = NSCharacterSet.letters
//            let digits = NSCharacterSet.decimalDigits
//
//            var invalidSearchText = false
//            let textFieldValue: NSString? = textField.text as NSString?
//            if let newText = textFieldValue?.replacingCharacters(in: range, with: string) {
//
//                self.searchButton.isEnabled = newText.isNotEmpty
//
//                if newText.count > 20 {
//                    return false
//                }
//
//                if textField.text?.count ?? 0 < newText.count, let formattedText = presenter?.formatTextEntry(text: newText) {
//                    textField.text = formattedText
//                    return false
//                }
//
//                invalidSearchText = newText.isEmpty == true
//
//            } else {
//                invalidSearchText = true
//            }
//            clearTextButton?.isHidden = invalidSearchText
//
//            return true
