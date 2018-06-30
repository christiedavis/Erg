//
//  AddWorkoutView.swift
//  erg
//
//  Created by Christie on 30/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import Foundation

import UIKit

enum InputType {
    case time
    case distance
}

protocol InputCellDelegate: class {
    func updatePiece(pieceDTO: PieceDTO)
}

class AddWorkoutView: BaseView {
    
    @IBOutlet var timeView: UIView!
    @IBOutlet weak var hoursInput: UITextField!
    @IBOutlet weak var minuteInout: UITextField!
    @IBOutlet weak var secondInput: UITextField!
    
    @IBOutlet var distanceView: UIView!
    @IBOutlet weak var distanceInput: UITextField!
    
    @IBOutlet var rateView: UIView!
    @IBOutlet weak var rateInput: UITextField?
    
    @IBOutlet var splitView: UIView!
    @IBOutlet weak var splitInput: UITextField!
    
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet weak var topDivider: UIView!
    //    @IBOutlet weak var bottomDivider: UIView!
    
    var hours: String = ""
    var mins: String = ""
    var secs: String = ""
    
    var inputType: InputType?
    var pieceDto: PieceDTO? {
        didSet {
            cellDelegate?.updatePiece(pieceDTO: self.pieceDto!)
        }
    }
    weak var cellDelegate: InputCellDelegate?
    
    func setup(_ inputType: InputType, _ piece: PieceDTO) {
        self.pieceDto = piece
        self.inputType = inputType
        
        if inputType == .distance {
            self.stackView.addArrangedSubview(distanceView)
            self.stackView.addArrangedSubview(timeView)
        } else if inputType == .time {
            self.stackView.addArrangedSubview(timeView)
            self.stackView.addArrangedSubview(distanceView)
        }
        self.stackView.addArrangedSubview(rateView)
        self.stackView.addArrangedSubview(splitView)
        
        rateInput?.keyboardType = .numberPad
        distanceInput.keyboardType = .numberPad
        splitInput.keyboardType = .decimalPad
        rateInput?.delegate = self
        distanceInput.delegate = self
        splitInput.delegate = self
        secondInput.delegate = self
        minuteInout.delegate = self
        hoursInput.delegate = self
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    @objc
    func dismissKeyboard() {
        if hoursInput?.isFirstResponder ?? false {
            hoursInput?.resignFirstResponder()
            return
        }
        if minuteInout?.isFirstResponder ?? false {
            minuteInout?.resignFirstResponder()
            return
        }
        if secondInput?.isFirstResponder ?? false {
            secondInput?.resignFirstResponder()
            return
        }
        
        if distanceInput?.isFirstResponder ?? false {
            distanceInput?.resignFirstResponder()
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

extension AddWorkoutView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == Constants.InputTags.rateInput {
            pieceDto?.rate = rateInput?.text ?? ""
        }
        
        if textField.tag == Constants.InputTags.aveSplitInput {
            pieceDto?.aveSplit = splitInput.text ?? ""
        }
        
        if textField.tag == Constants.InputTags.distanceInput {
            pieceDto?.distance = distanceInput?.text ?? ""
        }
        
        if textField.tag == Constants.InputTags.hourInput || textField.tag == Constants.InputTags.minsInput || textField.tag == Constants.InputTags.secInput {
            
            let minsToSave: String = self.minuteInout.text ?? "00"
            let secondsToSave: String = self.secondInput.text ?? "00"

            if let myHours = self.hoursInput.text, !myHours.isEmpty {
                pieceDto?.time = "\(myHours):\(minsToSave).\(secondsToSave)"

            } else {
                pieceDto?.time = "\(minsToSave).\(secondsToSave)"

            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == Constants.InputTags.rateInput {
            pieceDto?.rate = rateInput?.text ?? ""
            return formatRateEntry(textField, range: range, string: string)
        }
        
        if textField.tag == Constants.InputTags.aveSplitInput {
            pieceDto?.aveSplit = splitInput.text ?? ""
            return formatSplitEntry(textField, range: range, string: string)
        }
        
        if textField.tag == Constants.InputTags.distanceInput {
            pieceDto?.distance = distanceInput?.text ?? ""
            return true
        }
        
        if textField.tag == Constants.InputTags.hourInput {
            hours = getNewText(textField, range: range, string: string)
            return formatTimeEntry()
        }
        if textField.tag == Constants.InputTags.minsInput {
            mins = getNewText(textField, range: range, string: string)
            return formatTimeEntry()
        }
        if textField.tag == Constants.InputTags.secInput {
            secs = getNewText(textField, range: range, string: string)
            return formatTimeEntry()
        }
        return true
    }
    
    func getNewText(_ textField: UITextField, range: NSRange, string: String) -> String {
        let textFieldValue: NSString? = textField.text as NSString?
        if let newText = textFieldValue?.replacingCharacters(in: range, with: string) {
            return newText
        }
        return ""
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
        pieceDto?.aveSplit = textField.text ?? ""
        return true
    }
    
    func formatTimeEntry() -> Bool {
        let minsToSave: String = self.minuteInout.text ?? "00"
        let secondsToSave: String = self.secondInput.text ?? "00"
        
        if let myHours = self.hoursInput.text {
            pieceDto?.time = "\(myHours):\(minsToSave).\(secondsToSave)"
            
        } else {
            pieceDto?.time = "\(minsToSave).\(secondsToSave)"
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

