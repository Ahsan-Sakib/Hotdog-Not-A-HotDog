//
//  ViewController.swift
//  HotDog
//
//  Created by Ahsanul Kabir on 4/4/20.
//  Copyright © 2020 ahsanul.kabir. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = pickedImage
            let ciImage = CIImage(image: pickedImage)
            detectImage(image: ciImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func detectImage(image : CIImage?)  {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Fail to get model")
        }
       let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model fail to process image")
            }
            
            print(results)
        })
        
        let handler = VNImageRequestHandler(ciImage: image!)
        
        do {
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
        
    }

    @IBAction func tapImageButton(_ sender: Any) {
        present(imagePicker, animated: false, completion: nil)
    }
    
}



