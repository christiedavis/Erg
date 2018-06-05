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

class MachineLearningViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var error: NSError?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                
                //access granted
            } else {
                
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage]
        self.imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
