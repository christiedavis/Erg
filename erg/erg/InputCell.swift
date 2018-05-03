//
//  InputCell.swift
//  erg
//
//  Created by Christie on 13/05/17.
//  Copyright © 2017 star. All rights reserved.
//

import UIKit

enum InputType {
   case time
   case distance
//        split,
//        rate,
//        heartRate,
//        header
}

protocol InputCellDelegate: class {
    func updatePiece(pieceDTO: PieceDTO)
}

class InputCell: UITableViewCell {

    @IBOutlet weak var primaryLabel: UILabel?
    @IBOutlet weak var primaryInput: UITextField?

    @IBOutlet weak var secondaryLabel: UILabel?
    @IBOutlet weak var secondaryInput: UITextField?
    
    @IBOutlet weak var rateLabel: UILabel?
    @IBOutlet weak var rateInput: UITextField?
    
    @IBOutlet weak var topDivider: UIView!
    @IBOutlet weak var bottomDivider: UIView!
    
    @IBOutlet var inputBottomConstraint: NSLayoutConstraint?
    
    var inputType: InputType?
    var pieceDto: PieceDTO? {
        didSet {
            cellDelegate?.updatePiece(pieceDTO: self.pieceDto!)
        }
    }
    static var cellName: String = "InputCell"
    
    weak var cellDelegate: InputCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // not called
    }
    
    private func setup() {
        bottomDivider.backgroundColor = UIColor.gray
        topDivider.backgroundColor = .gray
        
        topDivider.isHidden = true
        bottomDivider.isHidden = true
        
        inputBottomConstraint?.constant = 15
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(_ inputType: InputType, _ piece: PieceDTO) {
        setup()
        self.pieceDto = piece
        self.inputType = inputType
        
        rateLabel?.attributedText = "Rate".apply(font: UIFont.regularFont(14))
        
        switch inputType {
            case .time:
                primaryLabel?.attributedText = "Time:".apply(font: UIFont.regularFont(14))
                
                secondaryLabel?.attributedText = "Distance:".apply(font: UIFont.regularFont(14))
                
            case .distance:
                primaryLabel?.attributedText = "Distance:".apply(font: UIFont.regularFont(14))
                
                secondaryLabel?.attributedText = "Time:".apply(font: UIFont.regularFont(14))
        }
    }

    @IBAction func editingDidChange(_ sender: Any) {
        if let inputType = self.inputType, let textInput = sender as? UITextField {
            
            if textInput.tag == Constants.InputTags.rateInput {
                pieceDto?.rate = Int(rateInput?.text ?? "-1")
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
