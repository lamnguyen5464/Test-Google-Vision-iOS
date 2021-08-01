//
//  UIImage+Extention.swift
//  WhereMyImage
//
//  Created by Lam Nguyen on 01/08/2021.
//

import UIKit
import Photos

extension UIImage {
    static func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    static func cacheImageLocal(from url: URL?){
        if (url == nil || url?.lastPathComponent == ""){
            return
        }
        getData(from: url!) { data, response, error in
            if let data = data,   error == nil{
                let fileName = self.getImageNameFrom(url: url)
                let isDone = self.saveImage(image: UIImage(data: data)!, fileName: fileName)
            }
        }
    }
    
    static func loadImageLocal(imageUrl: URL) -> UIImage? {
        let name = self.getImageNameFrom(url: imageUrl)
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(name).path)
        }
        return nil
    }
    
    static func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        print("start getting data...")
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    static func saveImage(image: UIImage, fileName: String) -> Bool {
        guard let data = image.pngData() ?? image.jpegData(compressionQuality: 1) else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent(fileName)!)
            return true
        } catch {
            return false
        }
    }
    
    static func getImageNameFrom(url: URL?) -> String{
        return url?.lastPathComponent ?? ""
    }
}

