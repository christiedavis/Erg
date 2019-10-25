//
//  File.swift
//  erg
//
//  Created by Christie on 6/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import Foundation
import GoogleMobileVision

struct TextValue {
    var value: String?
    var type: InputStringType?
    
    var point1: CGPoint?
    var point2: CGPoint?
    var point3: CGPoint?
    var point4: CGPoint?
    
    init(value: String?, type: InputStringType?, cornerPoints: [NSValue]?) {
        
        self.value = value
        self.type = type
        let cgarray = cornerPoints?.map { (value: NSValue) -> CGPoint in
            return value.cgPointValue
        }
        point1 = cgarray?[0]
        point2 = cgarray?[1]
        point3 = cgarray?[2]
        point4 = cgarray?[3]
    }
}

enum InputStringType {
    case other
    case time
    case distance
    case rate
    case split
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
    
    func processImageData(_ textBlockFeatures:  [GMVFeature]?) -> PieceDTO {

        var lineArray: [String] = []
        var lineArrayProcessed: [String] = []

        var wordArray: [String] = []
        
        var allArray: [Line] = []
        
        var xArray: [Int] = []
        var columnData: [Column] = []
        
        var arrayOfData: [TextValue] = []
        
        // Iterate over each text block.
        textBlockFeatures?.forEach({ (feature: GMVFeature) in
            
            if let textBlock = feature as? GMVTextBlockFeature {
                
                NSLog("Text Block: %@", NSCoder.string(for: textBlock.bounds));
                NSLog(" Text Block: language: \(textBlock.language) , value: \(textBlock.value)")
                
                
//                if let firstLine = textBlock.lines.first, let isFirstANumber = self.processLine(firstLine) {
                // For each text block, iterate over each line.
                    textBlock.lines.forEach({ (textLine: GMVTextLineFeature) in
                        
                        lineArray.append(textLine.value)
                        if let newLine = self.processLine(textLine) {
                            
                            lineArrayProcessed.append(newLine.value)
                            var line = Line(line: newLine.value, words: [])
                            
                            NSLog("Text Line: %@", NSCoder.string(for: newLine.bounds));
                            NSLog("text line: lang: %@ value: %@", newLine.language, newLine.value);
                            
                            // For each line, iterate over each word.
                            newLine.elements.forEach({ (textElement: GMVTextElementFeature) in
                                
                                
                                
                                
                                columnArray.append(Int(textElement.bounds.minX))
                                let inputType = self.determineInputType(textElement)
                                let value = TextValue(value: textElement.value, type: inputType, cornerPoints: textElement.cornerPoints)
                                arrayOfData.append(value)
                                switch inputType {
                                case .rate:
                                    NSLog("RATE \(textElement.value)")
                                    
                                case .distance:
                                    NSLog("DISTANCE \(textElement.value)")

                                case .time:
                                    NSLog("TIME \(textElement.value)")

                                case .split:
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
//                }
            }
        })
        
        NSLog("\(allArray)")
        NSLog("\(columnArray)")
        
        return self.processDataArray(arrayOfData)
    }
    
    private func processDataArray(_ array: [TextValue]) -> PieceDTO {
        
        let timeArray = array.filter({ $0.type == .time })
        let distanceArray = array.filter({ $0.type == .distance })
        let rateArray = array.filter({ $0.type == .rate })

        
        var distance = "", split = "", rate = "", time = ""
        var distancey: CGFloat = 1000, splity: CGFloat = 1000, ratey: CGFloat = 0, timey: CGFloat = 1000

        let maxxxx = distanceArray.max { (val1, val2) -> Bool in
            return (Int(val1.value ?? "0") ?? 0) <= (Int(val2.value ?? "0") ?? 0)
        }
        
        for rateValue in rateArray {
            
            if (rateValue.point1?.y)! > ratey {
                rate =  rateValue.value ?? ""
            }
        }
        
        
        let newPeice = PieceDTO(rowId: 0, distance: maxxxx?.value ?? "", time: "", rate: rate, aveSplit: "")
        return newPeice
        
    }
}
