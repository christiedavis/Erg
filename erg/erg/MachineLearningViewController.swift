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

import Vision

class MachineLearningViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    var session = AVCaptureSession()
    var requests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLiveVideo()
        startTextDetection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }
    
    func startLiveVideo() {
        //1
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        //2
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        //3
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = imageView.bounds
        imageView.layer.addSublayer(imageLayer)
        
        session.startRunning()
    }
    
    func startTextDetection() {
        let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        textRequest.reportCharacterBoxes = true
        self.requests = [textRequest]
    }

    func detectTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results else {
            print("no result")
            return
        }
        
        let result = observations.map({ $0 as? VNTextObservation })
        DispatchQueue.main.async() {
            
            self.imageView.layer.sublayers?.removeSubrange(1...)
            
            for region in result {
                guard let rg = region else {
                    continue
                }
                
                self.highlightWord(box: rg)
                
                if let boxes = region?.characterBoxes {
                    
                    for characterBox in boxes {
                        self.highlightLetters(box: characterBox)
                    }
                }
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage]
        self.imageView.image = image as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
  
    func highlightLetters(box: VNRectangleObservation) {
        let xCord = box.topLeft.x * imageView.frame.size.width
        let yCord = (1 - box.topLeft.y) * imageView.frame.size.height
        let width = (box.topRight.x - box.bottomLeft.x) * imageView.frame.size.width
        let height = (box.topLeft.y - box.bottomLeft.y) * imageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 1.0
        outline.borderColor = UIColor.blue.cgColor
        
        imageView.layer.addSublayer(outline)
    }
    
    func highlightWord(box: VNTextObservation) {
        guard let boxes = box.characterBoxes else {
            return
        }
        
        var maxX: CGFloat = 9999.0
        var minX: CGFloat = 0.0
        var maxY: CGFloat = 9999.0
        var minY: CGFloat = 0.0
        
        for char in boxes {
            if char.bottomLeft.x < maxX {
                maxX = char.bottomLeft.x
            }
            if char.bottomRight.x > minX {
                minX = char.bottomRight.x
            }
            if char.bottomRight.y < maxY {
                maxY = char.bottomRight.y
            }
            if char.topRight.y > minY {
                minY = char.topRight.y
            }
        }
        
        let xCord = maxX * imageView.frame.size.width
        let yCord = (1 - minY) * imageView.frame.size.height
        let width = (minX - maxX) * imageView.frame.size.width
        let height = (minY - maxY) * imageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 2.0
        outline.borderColor = UIColor.red.cgColor
        
        imageView.layer.addSublayer(outline)
    }
}

extension MachineLearningViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
            requestOptions = [.cameraIntrinsics: camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation.right, options: requestOptions)
        //CGImagePropertyOrientation(rawValue: 6)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}

extension MachineLearningViewController {
    private func takePhoto() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
                    
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
                
            }
        }
    }
}

//
//        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [], mediaType: nil, position: .back).devices.filter{ $0.hasMediaType(AVMediaType.video) && $0.position == AVCaptureDevice.Position.back }
//        if let captureDevice = devices.first as? AVCaptureDevice  {
//
//            var inputDevice: AVCaptureDeviceInput?
//            do {
//               inputDevice = try? AVCaptureDeviceInput(device: captureDevice)
//            }
//            catch {
//                inputDevice = nil
//                // error
//            }
//            if let inputDevice = inputDevice {
//            captureSession.addInput(inputDevice)
//            captureSession.sessionPreset = AVCaptureSession.Preset.photo
//            captureSession.startRunning()
////            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
////            stillImageOutput.availablePhotoCodecTypes = [AVVideoCodecJPEG]
////            stillImageOutput.availableLivePhotoVideoCodecTypes = [AVVideoCodecJPEG]
//            if captureSession.canAddOutput(stillImageOutput) {
//                captureSession.addOutput(stillImageOutput)
//            }
//
//             let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            previewLayer.bounds = view.bounds
//            previewLayer.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
//                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//            let cameraPreview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: view.bounds.height))
//            cameraPreview.layer.addSublayer(previewLayer)
//            cameraPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveToCamera(sender:))))
//            view.addSubview(cameraPreview)
//
//            }
//        }
//    }
//
//    @objc
//    func saveToCamera(sender: UITapGestureRecognizer) {
//
//        if let videoConnection = stillImageOutput.connection(with: AVMediaType.video) {
//
//            stillImageOutput.capturePhoto(with: AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG]), delegate: self)
//
//        }
//    }
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//}
//
//extension MachineLearningViewController: AVCapturePhotoCaptureDelegate {
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
//
//        output.data
//
//
//            (imageDataSampleBuffer, error) -> Void in
//            if let imageDataSampleBuffer = imageDataSampleBuffer, let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer) {
//                AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: imageDataSampleBuffer, previewPhotoSampleBuffer: nil)
//                if let image = UIImage(data: imageData) {
//                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                    // updtae thumbnail
//                }
//            }
//        }
//    }
//
//    }
//}
