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
    
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    private(set) lazy var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    
    private lazy var captureSession: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        guard
            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
            let input = try? AVCaptureDeviceInput(device: backCamera)
            else {
                return session
        }
        
        session.addInput(input)
        return session
    }()
    
  
    var textDetector: GMVDetector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraLayer)
        
        // register to receive buffers from the camera
        let videoOutput = AVCaptureVideoDataOutput()
//        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        self.captureSession.addOutput(videoOutput)
        
        // begin the session
        self.captureSession.startRunning()
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
   
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

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
        let processor = StringProcessor()
        processor.processImageData(textBlockFeatures)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
  
    private func takePhoto() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
                    self.simulatorPhoto()
                    let alert =  UIAlertController(title: "ERROR", message: "No camera available", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: nil))
                    alert.show(self, sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToAddWorkout" {
            if let destinationVc = segue.destination as? AddErgDataViewController {
                
                let piece = PieceDTO(rowId: 0)
                destinationVc.presenter = AddErgPresenter(piece: piece)
                destinationVc.presenter?.viewDelegate = destinationVc
            
            }
        }
    }
}


