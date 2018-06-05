//
//  Notes.swift
//  erg
//
//  Created by Christie on 5/06/18.
//  Copyright © 2018 star. All rights reserved.
//


//
//Unfortunately, we can't pass this CGRect directly into the Vision system. There are 3 different coordinate systems we have to convert between.
//
//UIKit coordinate space
//Origin in the top left corner
//Max height and width values of the screen size in points (320 x 568 on iPhone SE)
//AVFoundation coordinate space
//Origin in the top left
//Max height and width of 1
//Vision coordinate space
//Origin in the bottom left
//Max height and width of 1

// https://github.com/argman/EAST - ml ocr framework to port to core ml


// model creation in xcode playgrounds

//    import UIKit
//import CreateMLUI

//let builder = MLImageClassifierBuilder()
//builder.showInLiveView()
// requires mac update :(



// Custom video handling using core ml

//func startLiveVideo() {
//    session.sessionPreset = AVCaptureSession.Preset.photo
//    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
//
//    let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
//    let deviceOutput = AVCaptureVideoDataOutput()
//    deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
//    deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
//    session.addInput(deviceInput)
//    session.addOutput(deviceOutput)
//
//    let imageLayer = AVCaptureVideoPreviewLayer(session: session)
//    imageLayer.frame = imageView.bounds
//    imageView.layer.addSublayer(imageLayer)
//    captureLayer = imageLayer
//
//    session.startRunning()
//}
//
//func startTextDetection() {
//    let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
//    textRequest.reportCharacterBoxes = true
//    self.requests = [textRequest]
//}
//
//func detectTextHandler(request: VNRequest, error: Error?) {
//    guard let observations = request.results else {
//        print("no result")
//        return
//    }
//
//    let result = observations.map({ $0 as? VNTextObservation })
//    DispatchQueue.main.async() {
//
//        self.imageView.layer.sublayers?.removeSubrange(1...)
//
//        for region in result {
//            guard let rg = region else {
//                continue
//            }
//
//            self.highlightWord(box: rg)
//
//            if let boxes = region?.characterBoxes {
//
//
//                for characterBox in boxes {
//
//                    //                        let topLeftx = characterBox.topLeft.x
//                    //                        let topLefty = characterBox.topLeft.y
//                    //                        let width = characterBox.topRight.x - characterBox.topLeft.x
//                    //                        let height = characterBox.bottomLeft.y - characterBox.topLeft.y
//                    //
//                    //                        let fullCgimage = captureLayer? // self.imageView.image?.cgImage
//                    //
//                    //                        let cgimage: CGImage? = fullCgimage?.cropping(to: CGRect(x: topLeftx, y: topLefty, width: width, height: height))
//                    //                        if let cgimage = cgimage {
//                    //                            let uiimage = UIImage(cgImage: cgimage)
//                    //
//                    //                            let cvPxBuffer = self.CVPixelBufferRefFromUiImage(image: uiimage)
//                    //
//                    //                            let input = MNISTInput(image: cvPxBuffer!)
//                    //                        }
//                    //                        let input = MNISTInput(image: boxes)
//                    self.highlightLetters(box: characterBox)
//                }
//            }
//        }
//    }
//}
//func highlightLetters(box: VNRectangleObservation) {
//    let xCord = box.topLeft.x * imageView.frame.size.width
//    let yCord = (1 - box.topLeft.y) * imageView.frame.size.height
//    let width = (box.topRight.x - box.bottomLeft.x) * imageView.frame.size.width
//    let height = (box.topLeft.y - box.bottomLeft.y) * imageView.frame.size.height
//
//    let outline = CALayer()
//    outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
//    outline.borderWidth = 1.0
//    outline.borderColor = UIColor.blue.cgColor
//
//    imageView.layer.addSublayer(outline)
//}
//
//func highlightWord(box: VNTextObservation) {
//    guard let boxes = box.characterBoxes else {
//        return
//    }
//
//    var maxX: CGFloat = 9999.0
//    var minX: CGFloat = 0.0
//    var maxY: CGFloat = 9999.0
//    var minY: CGFloat = 0.0
//
//    for char in boxes {
//        if char.bottomLeft.x < maxX {
//            maxX = char.bottomLeft.x
//        }
//        if char.bottomRight.x > minX {
//            minX = char.bottomRight.x
//        }
//        if char.bottomRight.y < maxY {
//            maxY = char.bottomRight.y
//        }
//        if char.topRight.y > minY {
//            minY = char.topRight.y
//        }
//    }
//
//    let xCord = maxX * imageView.frame.size.width
//    let yCord = (1 - minY) * imageView.frame.size.height
//    let width = (minX - maxX) * imageView.frame.size.width
//    let height = (minY - maxY) * imageView.frame.size.height
//
//    let outline = CALayer()
//    outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
//    outline.borderWidth = 2.0
//    outline.borderColor = UIColor.red.cgColor
//
//    imageView.layer.addSublayer(outline)
//}
//
//func CVPixelBufferRefFromUiImage(image: UIImage) -> CVPixelBuffer? {
//    let size: CGSize = image.size
//    let cgImage = image.cgImage
//
//    let options: NSDictionary = NSDictionary(dictionary: [kCVPixelBufferCGImageCompatibilityKey: NSNumber(value: true),
//                                                          kCVPixelBufferCGBitmapContextCompatibilityKey : NSNumber(value: true)
//        ])
//
//    var pixelBuffer: CVPixelBuffer? = nil
//
//    let status: CVReturn = CVPixelBufferCreate(kCFAllocatorDefault, Int(size.width
//    ), Int(size.height ), kCVPixelFormatType_32ARGB, options, &pixelBuffer)
//
//
//
//    if status == kCVReturnSuccess, let pixelBuffer = pixelBuffer {
//
//        CVPixelBufferLockBaseAddress(pixelBuffer, []);
//        let pxdata = CVPixelBufferGetBaseAddress(pixelBuffer);
//        assert(pxdata != nil);
//
//        let rgbColorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB();
//
//        let context: CGContext = CGContext(data: pxdata, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: Int(4*size.width), space: rgbColorSpace, bitmapInfo: kCGImagePropertyHasAlpha as! UInt32)!
//
//        context.draw(image.cgImage as! CGImage, in: CGRect(x: 0, y: 0, width: (image.cgImage?.width)!, height: (image.cgImage?.height)!))
//
//        CVPixelBufferUnlockBaseAddress(pixelBuffer, []);
//    }
//
//    return pixelBuffer
//
//}
//}
//
//extension MachineLearningViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//
//        var requestOptions:[VNImageOption : Any] = [:]
//
//        if let camData = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, nil) {
//            requestOptions = [.cameraIntrinsics: camData]
//        }
//
//        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation.right, options: requestOptions)
//        //CGImagePropertyOrientation(rawValue: 6)
//
//        output
//
//        do {
//            try imageRequestHandler.perform(self.requests)
//        } catch {
//            print(error)
//        }
//    }
//}
/*
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
*/
