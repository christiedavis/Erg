//
//  MachineLearningViewController.swift
//  erg
//
//  Created by Christie on 4/06/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit
import AVFoundation

import UIKit
import AVFoundation
import ARKit
import GoogleMobileVision
import Vision

struct Line {
    var line: String = ""
    var words: [String] = []
}

struct Column {
    var xPos: Int = 0
    var value: [String] = []
}

class MachineLearningViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
  
    var textDetector: GMVDetector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textDetector = GMVDetector(ofType: GMVDetectorTypeText, options: [:])
        self.takePhoto()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage]
        self.imageView.image = image as? UIImage
        let textBlockFeatures = self.textDetector?.features(in: image as? UIImage, options: [:])
        self.processImageData(textBlockFeatures)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func simulatorPhoto() {
        let image = UIImage(named: "imgErg")
        DispatchQueue.main.async {
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.image = image
            
            let textBlockFeatures = self.textDetector?.features(in: image, options: [:])
            self.processImageData(textBlockFeatures)
        }
    }

    private func processImageData(_ textBlockFeatures:  [GMVFeature]?) {
        
        var lineArray: [String] = []
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
                    var line = Line(line: textLine.value, words: [])
                    
                    NSLog("Text Line: %@", NSStringFromCGRect(textLine.bounds));
                    NSLog("text line: lang: %@ value: %@", textLine.language, textLine.value);
                    
                    // For each line, iterate over each word.
                    textLine.elements.forEach({ (textElement: GMVTextElementFeature) in
                      
                        wordArray.append(textElement.value)
                        line.words.append(textElement.value)
                    })
                    allArray.append(line)
                })
            }
        })
        
        NSLog("\(allArray)")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
  
    private func takePhoto() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
                    self.simulatorPhoto()
//                    let alert =  UIAlertController(title: "ERROR", message: "No camera available", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
//
//                    alert.show(self, sender: self)
                    return
                }
                
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .camera
                picker.modalPresentationStyle = .fullScreen
                self.present(picker, animated: true, completion: nil)
                
            } else {
                self.simulatorPhoto()
            }
        }
    }
}
