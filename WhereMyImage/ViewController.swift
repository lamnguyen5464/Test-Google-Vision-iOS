//
//  ViewController.swift
//  WhereMyImage
//
//  Created by Lam Nguyen on 01/08/2021.
//

import UIKit
import MLKit


class ViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let image = UIImage(named: "cat1")
        
        img.image = image
        
        
        //
        
        let options = ImageLabelerOptions()
        options.confidenceThreshold = 0.7
        
        let labeler = ImageLabeler.imageLabeler(options: options)
        
        labeler.process(VisionImage(image: image!)){ labels, error in
            guard error == nil, let labels = labels else {
                return
            }
            for label in labels{
                print("label: \(label.index): \(label.confidence) - \(label.text)")
            }
            
        }
        
    }
}

