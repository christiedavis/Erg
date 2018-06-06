//
//  File.swift
//  erg
//
//  Created by Christie on 6/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import Foundation
import GoogleMobileVision

enum InputStringType {
    case other
    case time
    case distance
    case rate
}

extension String {
    func isDigits() -> Bool {
        let numericCharacterSet = NSCharacterSet.decimalDigits
        let unicodeScalar = self.unicodeScalars
        var isNumber: Bool = true
        // TODO: optimize
        unicodeScalar.forEach { (unicodeScalar) in
            if numericCharacterSet.contains(unicodeScalar) {
                
            } else {
                isNumber = false
                return
            }
        }
        
        return isNumber
    }
    
    func isNumber() -> Bool {
        let numericCharacterSet = NSCharacterSet.decimalDigits
        let punctuationCharSet = NSCharacterSet.punctuationCharacters
        
        let unicodeScalar = self.unicodeScalars
        var isNumber: Bool = true
        // TODO: optimize
        unicodeScalar.forEach { (unicodeScalar) in
            if numericCharacterSet.contains(unicodeScalar) || punctuationCharSet.contains(unicodeScalar) {
                
            } else {
                isNumber = false
                return
            }
        }
        
        return isNumber
    }
}

class StringProcessor {
    
    var columnArray: [Int] = []
    
    private func processLine(_ inputLine: GMVTextLineFeature) -> GMVTextLineFeature? {
        
        let firstWord = inputLine.elements.first
        
        if firstWord?.value.isNumber() ?? false {
            return inputLine
        }
        return nil
    }
    
    private func determineInputType(_ inputFeature: GMVTextElementFeature) -> InputStringType {
        
        if let inputString = inputFeature.value {
        
            if inputString.count == 2 {
                // rate
                return .rate
            }
            if inputString.isDigits() {
                // distance
                return .distance
            } else {
                // timestamp -> figure out distinguishing type based on x coord
                return .time
            }
        } else {
            return .other
        }
    }
    
    func processImageData(_ textBlockFeatures:  [GMVFeature]?) {

        var lineArray: [String] = []
        var lineArrayProcessed: [String] = []

        var wordArray: [String] = []
        
        var allArray: [Line] = []
        
        var xArray: [Int] = []
        var columnData: [Column] = []
        
        // Iterate over each text block.
        textBlockFeatures?.forEach({ (feature: GMVFeature) in
            
            if let textBlock = feature as? GMVTextBlockFeature {
                
                NSLog("Text Block: %@", NSStringFromCGRect(textBlock.bounds));
                NSLog(" Text Block: language: \(textBlock.language) , value: \(textBlock.value)")
                
                // For each text block, iterate over each line.
                textBlock.lines.forEach({ (textLine: GMVTextLineFeature) in
                    
                    lineArray.append(textLine.value)
                    if let newLine = self.processLine(textLine) {
                        
                        lineArrayProcessed.append(newLine.value)
                        var line = Line(line: newLine.value, words: [])
                        
                        NSLog("Text Line: %@", NSStringFromCGRect(newLine.bounds));
                        NSLog("text line: lang: %@ value: %@", newLine.language, newLine.value);
                        
                        // For each line, iterate over each word.
                        newLine.elements.forEach({ (textElement: GMVTextElementFeature) in
                            columnArray.append(Int(textElement.bounds.minX))
                            let inputType = self.determineInputType(textElement)
                            switch inputType {
                            case .rate:
                                NSLog("RATE \(textElement.value)")
                                
                            case .distance:
                                NSLog("DISTANCE \(textElement.value)")

                            case .time:
                                NSLog("TIME \(textElement.value)")

                            case .other:
                                NSLog("OTHER \(textElement.value)")
                            }
                            wordArray.append(textElement.value)
                            line.words.append(textElement.value)
                        })
                        allArray.append(line)
                        
                    }
                })
            }
        })
        
        NSLog("\(allArray)")
        NSLog("\(columnArray)")
    }
}
