//
//  ViewController.swift
//  CoreMLSample
//
//  Created by SIN on 2017/08/08.
//  Copyright © 2017年 SAPPOROWORKS. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var iamgeView: UIImageView!
    @IBOutlet weak var textField: UITextView!
    
    var index = 0
    let max = 7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func changeAction(_ sender: Any) {
        let imageName = String(format: "%03d", index + 1)
        if let image = UIImage(named: imageName) {
            iamgeView.image = image
            coreMLRequest(image: image)
        }
        index += 1
        if (max <= index) {
            index = 0
        }
    }
    
    func coreMLRequest(image:UIImage) {
        // 処理時間計測
        let t = Double(time(nil))
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {//Inceptionv3 VGG16 SqueezeNet GoogLeNetPlaces
            fatalError("faild create VMCoreMLModel")
        }
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("faild convert CIImage")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Error faild results")
            }
            let elapsed = Double(time(nil)) - t
            if let classification = results.first {
                print("identifier = \(classification.identifier)")
                print("confidence = \(classification.confidence)")
                print("elapsed = \(elapsed)")

            } else {
                print("error")
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        guard (try? handler.perform([request])) != nil else {
            fatalError("faild handler.perform")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

