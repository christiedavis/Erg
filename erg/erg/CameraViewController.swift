//
//  CameraViewController.swift
//  
//
//  Created by Christie on 16/06/18.
//

import UIKit
import UIKit
import AVFoundation
import Vision
import GoogleMobileVision

class CameraViewController: BaseViewController {
    
    @IBOutlet var placeHolderView: UIView?
    @IBOutlet var overlayView: UIView?

    var session: AVCaptureSession?
    var videoDataOutput: AVCaptureVideoDataOutput?
    var videoDataOutputQueue: DispatchQueue?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var textDetector: GMVDetector?
    
//    init() {
//        super.init()
//        videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")//    dispatch_queue_create("VideoDataOutputQueue", DispatchQue  ue)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")

    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up default camera settings.
//        self.session = AVCaptureSession()
//        self.session?.sessionPreset = AVCaptureSession.Preset.medium;
//        self.updateCameraSelection()
        
        // Set up video processing pipeline.
//        self.setUpVideoProcessing()
//        
//        // Set up camera preview.
//        self.setUpCameraPreview()
//        
//        // Initialize text detector.
//        self.textDetector = GMVDetector(ofType: GMVDetectorTypeText, options: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.previewLayer?.frame = self.view.layer.bounds;
        if let frame = previewLayer?.frame {
            
            self.previewLayer?.position = CGPoint(x: frame.midX, y: frame.midY)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.session?.startRunning()
//        [self.session startRunning];
    }
                    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.session?.stopRunning()
        self.cleanupCaptureSession()
    }
    
    
    func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
    // Camera rotation needs to be manually set when rotation changes.
//        if let previewLayer = previewLayer {
//            if (toInterfaceOrientation == .portrait) {
//                previewLayer.connection.videoOrientation = .portrait;
//            } else if (toInterfaceOrientation == .portraitUpsideDown) {
//                previewLayer.connection.videoOrientation = .portraitUpsideDown;
//            } else if (toInterfaceOrientation == .landscapeLeft) {
//                previewLayer.connection.videoOrientation = .landscapeLeft;
//            } else if (toInterfaceOrientation == .landscapeRight) {
//                previewLayer.connection.videoOrientation = .landscapeRight;
//            }
//        }
    }
}

extension CameraViewController {

    func deviceOrientationFromInterfaceOrientation() -> UIDeviceOrientation {
        var defaultOrientation: UIDeviceOrientation = .portrait
//    UIDeviceOrientation defaultOrientation = UIDeviceOrientationPortrait;
        
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft:
            defaultOrientation = .landscapeRight

        case .landscapeRight:
            defaultOrientation = .landscapeLeft
            
        case .portrait:
            defaultOrientation = .portrait
            
        case .portraitUpsideDown:
            defaultOrientation = .portraitUpsideDown
        default:
            defaultOrientation = .portrait
        }
        return defaultOrientation
//    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
//    case UIInterfaceOrientationLandscapeLeft:
//        defaultOrientation = UIDeviceOrientationLandscapeRight;
//        break;
//    case UIInterfaceOrientationLandscapeRight:
//        defaultOrientation = UIDeviceOrientationLandscapeLeft;
//        break;
//    case UIInterfaceOrientationPortraitUpsideDown:
//        defaultOrientation = UIDeviceOrientationPortraitUpsideDown;
//        break;
//    case UIInterfaceOrientationPortrait:
//    default:
//        defaultOrientation = UIDeviceOrientationPortrait;
//        break;
//    }
//    return defaultOrientation;
    }
    
    // Normalized corner points based on |width| and |heigh|.
    func convertPoints(points: [Int], width: Float, height: Float) -> [Int] {
//     - (NSArray<NSValue *> *)convertPoints:(NSArray<NSValue *> *)points
//width:(CGFloat)width
//height:(CGFloat)height {
        
//        NSMutableArray *converted = [[NSMutableArray alloc] initWithCapacity:points.count];
//        for (NSUInteger i = 0; i < points.count; i++) {
//            CGPoint normalizedPoint = CGPointMake(points[i].CGPointValue.x / width,
//                                                  points[i].CGPointValue.y / height);
//            [converted addObject:[NSValue valueWithCGPoint:
//                [self.previewLayer pointForCaptureDevicePointOfInterest:normalizedPoint]]];
//        }
//        return converted;
//        }
        return []
    }
}

//#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    size_t imageWidth = CVPixelBufferGetWidth(imageBuffer);
//    size_t imageHeight = CVPixelBufferGetHeight(imageBuffer);
//
//    AVCaptureDevicePosition devicePosition = AVCaptureDevicePositionBack;
//
//    // Establish the image orientation.
//    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
//    GMVImageOrientation orientation = [GMVUtility
//        imageOrientationFromOrientation:deviceOrientation
//        withCaptureDevicePosition:devicePosition
//        defaultDeviceOrientation:[self deviceOrientationFromInterfaceOrientation]];
//    NSDictionary *options = @{
//        GMVDetectorImageOrientation : @(orientation)
//    };
//
//    // Detect features using GMVDetector.
//    NSArray<GMVTextBlockFeature *> *textBlocks = [self.textDetector featuresInBuffer:sampleBuffer
//        options:options];
//    NSLog(@"detect text: %lu", textBlocks.count);
//
//
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        // Remove previously added annotation.
//        for (UIView *featureview in self.overlayView.subviews) {
//            [featureview removeFromSuperview];
//        }
//
//        // Highlight detected text blocks.
//        for (GMVTextBlockFeature *textBlock in textBlocks) {
//            NSArray *points = [self convertPoints:textBlock.cornerPoints
//                width:imageWidth
//                height:imageHeight];
//            [DrawingUtility addShape:points toView:self.overlayView withColor:[UIColor purpleColor]];
//
//            // Highlight detected text lines.
//            for (GMVTextLineFeature *textLine in textBlock.lines) {
//                NSArray *points = [self convertPoints:textLine.cornerPoints
//                    width:imageWidth
//                    height:imageHeight];
//                [DrawingUtility addShape:points toView:self.overlayView withColor:[UIColor orangeColor]];
//
//                // Render detected text elements.
//                for (GMVTextElementFeature *textEle in textLine.elements){
//                    CGRect normalizedRect = CGRectMake(textEle.bounds.origin.x / imageWidth,
//                                                       textEle.bounds.origin.y / imageHeight,
//                                                       textEle.bounds.size.width / imageWidth,
//                                                       textEle.bounds.size.height / imageHeight);
//                    CGRect convertedRect =
//                        [self.previewLayer rectForMetadataOutputRectOfInterest:normalizedRect];
//                    [DrawingUtility addRectangle:convertedRect
//                        toView:self.overlayView
//                        withColor:[UIColor greenColor]];
//                    UILabel *label = [[UILabel alloc] initWithFrame:convertedRect];
//                    label.text = textEle.value;
//                    label.adjustsFontSizeToFitWidth = YES;
//                    [self.overlayView addSubview:label];
//                }
//            }
//        }
//
//        });
    }


//#pragma mark - Camera setup

    func cleanupVideoProcessing() {
        if let videoDataOutput = self.videoDataOutput {
            self.session?.removeOutput(videoDataOutput)
        }
        self.videoDataOutput = nil;
    }
    
    func cleanupCaptureSession() {
        self.session?.stopRunning()
        self.cleanupVideoProcessing()
        
        self.session = nil;
        self.previewLayer?.removeFromSuperlayer()
    }
        
    func setUpVideoProcessing() {
//        self.videoDataOutput = AVCaptureVideoDataOutput()
//        let rgbOutputSettings = [kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA]
////            self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
////            NSDictionary *rgbOutputSettings = @{
////                (__bridge NSString*)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)
////            };
//        self.videoDataOutput?.videoSettings = rgbOutputSettings
//        if self.session?.canAdd(self.videoDataOutput) == false {
//            self.cleanupVideoProcessing()
//            return
//        }
//        self.videoDataOutput?.alwaysDiscardsLateVideoFrames = true
//        self.videoDataOutput?.sampleBufferDelegate = self
//        self.videoDataOutput?.sampleBufferCallbackQueue = self.videoDataOutputQueue
//        self.session?.addOutput(self.videoDataOutput)
//            [self.videoDataOutput setVideoSettings:rgbOutputSettings];
//
//            if (![self.session canAddOutput:self.videoDataOutput]) {
//                [self cleanupVideoProcessing];
//                NSLog(@"Failed to setup video output");
//                return;
//            }
//            [self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
//            [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
//            [self.session addOutput:self.videoDataOutput];
        }
            
    func setUpCameraPreview() {
//        if let session = self.session {
//            self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
//            self.previewLayer?.backgroundColor = UIColor.white.cgColor
//            self.previewLayer?.videoGravity = .resizeAspect
//            let rootLayer: CALayer? = self.placeHolderView?.layer
//
//            rootLayer?.masksToBounds = true
//            self.previewLayer?.frame = (rootLayer?.bounds)!
//            rootLayer?.addSublayer(self.previewLayer!)
//            }
    }
                
        func updateCameraSelection() {
            self.session?.beginConfiguration()

//            // Remove old inputs
            if let oldInputs = self.session?.inputs {
                for oldInput in oldInputs {
                    self.session?.removeInput(oldInput)
                }
                
                
//                let desiredPos: AVCaptureDevice.Position = .back
//                if let input = self.captureDeviceInputForPosition(desiredPosition: desiredPos) {
//                    // Succeeded, set input and update connection states
//                    self.session?.addInput(input)
//                } else {
//                    // Failed, restore old inputs
//                    for input in oldInputs {
//                        self.session?.addInput(input)
//                    }
//                }
            }
            self.session?.commitConfiguration()
        }
    
  
    

    func captureDeviceInputForPosition(desiredPosition: AVCaptureDevice.Position) -> AVCaptureDeviceInput? {
//        AVCaptureDeviceDiscoverySession.devices
//        for device in AVCaptureDevice.devices(for: .video) {
//            if device.position == desiredPosition {
//                do {
//                    let input: AVCaptureDeviceInput = try AVCaptureDeviceInput(device: device)
//                    return input
//                } catch {
//
//                }
//            }
//        }
        return nil
//    }
    }
}
        
//        for (AVCaptureDevice *device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
//            if (device.position == desiredPosition) {
//                NSError *error = nil;
//                AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
//                    error:&error];
//                if (error) {
//                    NSLog(@"Could not initialize for AVMediaTypeVideo for device %@", device);
//                } else if ([self.session canAddInput:input]) {
//                    return input;
//                }
//            }
//        }
//        return nil;
//    }
//}
