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

protocol Dismissable: class {
    var shouldDismissOnAppear: Bool { get set }

}
// THIS ONE USES GOOGLE VISION
class MachineLearningViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Dismissable {
    
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var pieceDTO: PieceDTO?
    
    @IBOutlet var classificationLabel: UILabel!
    
    var shouldDismissOnAppear: Bool = false
  
    var textDetector: GMVDetector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.textDetector = GMVDetector(ofType: GMVDetectorTypeText, options: [:])
        self.takePhoto()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.shouldDismissOnAppear == true {
            dismissView(self)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage]
       
        if let uiimage = image as? UIImage {
            self.imageView.image = uiimage
            let textBlockFeatures = self.textDetector?.features(in: uiimage, options: [:])
            self.processImageData(textBlockFeatures)
            self.imageClassification(image: uiimage)
        }
        picker.dismiss(animated: true, completion: nil)

    }
   
    func imageClassification(image: UIImage?) {
        guard let classificationRequest = self.classificationRequest(), let image = image, let ciiMahe = CIImage(image: image) else {
            return
        }


        DispatchQueue.global(qos: .userInitiated).async {

            let handler = VNImageRequestHandler(ciImage: ciiMahe, options: [:] )

            do {
                try handler.perform([classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func classificationRequest() -> VNCoreMLRequest? {
        
        if let model = try? VNCoreMLModel(for: ImageClassifier_erg_2_1().model) {
        
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        }
        return nil
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as? [VNClassificationObservation]
            print(results.count)
            
            self.classificationLabel.text = classifications?.first?.identifier
        }
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

    private func processImageData(_ textBlockFeatures:  [GMVFeature]?) {
        let processor = StringProcessor()
        self.pieceDTO = processor.processImageData(textBlockFeatures)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
  
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
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToAddWorkout" {
            if let destinationVc = segue.destination as? AddErgDataViewController {
                
                destinationVc.presenter = AddErgPresenter(piece: pieceDTO)
                destinationVc.presenter?.viewDelegate = destinationVc
                destinationVc.dissmissableCompletetionView = self
            }
        }
    }
    
    @IBAction func retaketapped(_ sender: Any) {
        self.takePhoto()
    }
    
    @IBAction func addErgTapped(_ sender: Any) {
        let addErgVC = AddErgDataViewController()
        addErgVC.presenter = AddErgPresenter(piece: pieceDTO)
        addErgVC.presenter?.viewDelegate = addErgVC
        addErgVC.dissmissableCompletetionView = self
        addErgVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(addErgVC, animated: true)
    }
}
