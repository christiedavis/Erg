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
  
    }
    
    func setup(_ inputType: InputType, _ piece: PieceDTO) {
        self.pieceDto = piece
        self.inputType = inputType
    
        rateLabel?.text = "Rate"
        
        switch inputType {
            case .time:
                primaryLabel?.text = "Time:"
                primaryUnits.text = "mins"
                primaryInput?.keyboardType = .numbersAndPunctuation
                secondaryLabel?.text = "Distance:"
                secondaryInput?.keyboardType = .numberPad
                secondaryUnits.text = "meters"
            case .distance:
                primaryLabel?.text = "Distance:"
                primaryUnits.text = "meters"
                primaryInput?.keyboardType = .numberPad
                secondaryLabel?.text = "Time:"
                secondaryUnits.text = "mins"
                secondaryInput?.keyboardType = .numbersAndPunctuation
        }
        
        splitInput.keyboardType = .decimalPad
        rateInput?.delegate = self
        primaryInput?.delegate = self
        secondaryInput?.delegate = self
        splitInput.delegate = self
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc
    func dismissKeyboard() {
        if primaryInput?.isFirstResponder ?? false {
            primaryInput?.resignFirstResponder()
            return
        }
        
        if secondaryInput?.isFirstResponder ?? false {
            secondaryInput?.resignFirstResponder()
            return
        }
        
        if rateInput?.isFirstResponder ?? false {
            rateInput?.resignFirstResponder()
            return
        }
        
        if splitInput?.isFirstResponder ?? false {
            splitInput?.resignFirstResponder()
        }
    }
}

extension AddSessionCell: UITextFieldDelegate {

func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if let inputType = self.inputType {
            
            if textField.tag == Constants.InputTags.rateInput {
                pieceDto?.rate = rateInput?.text ?? ""
                return formatRateEntry(textField, range: range, string: string)
            }
            
            if textField.tag == Constants.InputTags.aveSplitInput {
                pieceDto?.aveSplit = splitInput.text ?? ""
                return formatSplitEntry(textField, range: range, string: string)
            }
            
            switch inputType {
            case .time:
                if textField.tag == Constants.InputTags.primaryInput {
                    pieceDto?.time = primaryInput?.text ?? ""
                } else {
                    pieceDto?.distance = secondaryInput?.text ?? ""
                }
                return formatTimeEntry(textField, range: range, string: string)
                
            case .distance:
                if textField.tag == Constants.InputTags.primaryInput {
                    pieceDto?.distance = primaryInput?.text ?? ""
                } else {
                    pieceDto?.time = secondaryInput?.text ?? ""
                }
                return true
            }
        }
        return true
    }
    
    func formatRateEntry(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let textFieldValue: NSString? = textField.text as NSString?
        if let newText = textFieldValue?.replacingCharacters(in: range, with: string) {
            
            if newText.count > 2 {
                return false
            }
        }
        return true
    }
    
    func formatSplitEntry(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let textFieldValue: NSString? = textField.text as NSString?
        if let newText = textFieldValue?.replacingCharacters(in: range, with: string) {
            
            if newText.count > 7 {
                return false
            }
            
            if textField.text?.count ?? 0 < newText.count, let formattedText = self.formatSplit(text: newText) {
                textField.text = formattedText
                return false
            }
        }
        return true
    }

    func formatTimeEntry(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        // TODO:  make it so it only takes numbers and the correct punctiation
        let textFieldValue: NSString? = textField.text as NSString?
        if let newText = textFieldValue?.replacingCharacters(in: range, with: string) {
            
            if newText.count > 15 {
                return false
            }
        }
        return true
    }
    
    func formatSplit(text: String) -> String? {
        var searchString = text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let colonPos = 1, dotPos = 4
        
        if searchString.count == colonPos {
            return "\(searchString):"

        } else if searchString.count == dotPos {
            return "\(searchString)."
        } else if searchString.count == (colonPos + 1) {
            if searchString.stringAtIndex(colonPos) != ":" {
                searchString.insert(":", at: searchString.index(searchString.startIndex, offsetBy: colonPos))
                return searchString
            }
        } else if searchString.count == (dotPos + 1) {
            if searchString.stringAtIndex(dotPos) != "1" {
                searchString.insert("1", at: searchString.index(searchString.startIndex, offsetBy: dotPos))
                return searchString
            }
        }
        return nil
    }
}
