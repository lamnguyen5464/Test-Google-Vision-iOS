//
//  ViewController.swift
//  WhereMyImage
//
//  Created by Lam Nguyen on 01/08/2021.
//

import UIKit
import MLKit
import Photos


class ViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                print("Found \(allPhotos.count) assets")
                
                let image = UIImage.getAssetThumbnail(asset: allPhotos.firstObject!)
                
                
                DispatchQueue.main.async{
                    
                    self.img.image = image
                }
                
                let options = ImageLabelerOptions()
                options.confidenceThreshold = 0.7
                
                let labeler = ImageLabeler.imageLabeler(options: options)
                
                labeler.process(VisionImage(image: image)){ labels, error in
                    guard error == nil, let labels = labels else {
                        return
                    }
                    for label in labels{
                        print("label: \(label.index): \(label.confidence) - \(label.text)")
                    }
                    
                }
                
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                // Should not see this when requesting
                print("Not determined yet")
            case .limited:
                print("limited")
            default:
                print("default")
            }
        }
        
        
        
        
        let url = URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRv5yISWmMAg4xPXIPHewlfAtOIVcX7RsFi5A&usqp=CAU")
        
        let _ = UIImage.getData(from: url!){ data, response, error in
            guard error == nil, let data = data else {
                return
            }
            print("herer")
            let image = UIImage(data: data)
            
            //            DispatchQueue.main.async {
            //                self.img.image = image
            //            }
            
            //
            
            
        }
        
    }
}

