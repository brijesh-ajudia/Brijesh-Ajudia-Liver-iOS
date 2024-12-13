//
//  UIColor+Extension.swift
//  Demo_ Liver
//
//  Created by Brijesh Ajudia on 12/12/24.
//

import Foundation
import UIKit
import SDWebImage
import Photos

extension UIImageView {
    
    func loadImageFromURL(themeURLString: String?, placeholderImage: UIImage? = nil, placeHolderErrorImage: UIImage? = nil) {
        guard let themeURL = themeURLString, let imageURL = URL.init(string: themeURL) else {
            image = placeholderImage ?? UIImage(named: "placeholder")
            return
        }
        
        self.image = placeholderImage
        sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"), options: .retryFailed) { (image, error, cacheType, url) in
            if error != nil {
                self.image = placeHolderErrorImage ?? UIImage(named: "placeholder")
            }
            else {
                if image != nil {
                    self.image = image
                }
                else {
                    self.image = placeholderImage ?? UIImage(named: "placeholder")
                }
            }
        }
    }
    
    func loadImageFromProfile(urlString: String?, placeholderImage: UIImage? = nil){
        guard let themeURL = urlString, let imageURL = URL.init(string: themeURL) else {
            image = placeholderImage ?? UIImage(named: "ic_placeholderAccount")
            return
        }
        
        sd_setImage(with: imageURL, placeholderImage: UIImage(named: "ic_placeholderAccount"), options: .retryFailed) { (image, error, cacheType, url) in
            if image != nil{
                self.image = image
            }
            else {
                self.image = placeholderImage ?? UIImage()
            }
        }
    }
    
    func setImageFromURL(imageString: String, placeHolderImage: UIImage? = nil, _ callback: ((_ imageFromURL: UIImage?, _ isSucess: Bool?) -> Void)?) {
        guard let imageURL = URL(string: imageString) else {
            callback?(placeHolderImage, false)
            return
        }
        
        sd_setImage(with: imageURL, placeholderImage: placeHolderImage, options: .retryFailed) { sdImage, error, cacheType, url in
            if error != nil {
                callback?(placeHolderImage, false)
            }
            else {
                if sdImage != nil {
                    callback?(sdImage, true)
                }
                else {
                    callback?(placeHolderImage, false)
                }
            }
        }
    }
    
    
    func setNetworkImage(url: URL, placeHolderImage: UIImage? = nil, indexPath: IndexPath? = nil, callback: ((_ image: UIImage?, _ indexPath: IndexPath?, _ error: Error?) -> Void)?) {
        let DOCUMENT_DIRECTORY = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let localFileURL = DOCUMENT_DIRECTORY.appendingPathComponent(url.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: localFileURL.path) {
            if let data = try? Data(contentsOf: localFileURL) {
                let localImage = UIImage(data: data)
                self.image = localImage
                callback?(localImage, indexPath, nil)
            }
            else {
                self.sd_setImage(with: url,
                                 placeholderImage: placeHolderImage,
                                 options: indexPath == nil ? .highPriority : SDWebImageOptions.avoidAutoSetImage,
                                 context: nil,
                                 progress: nil,
                                 completed: { (image: UIImage?, error: Error?, SDImageCacheType, url: URL?) in
                                    if let i = image {
                                        if let data = i.pngData() {
                                            try? data.write(to: localFileURL, options: Data.WritingOptions.atomic)
                                        }
                                    }
                                    callback?(image, indexPath, error)
                                 })
            }
            
        }
        else {
            self.sd_setImage(with: url,
                             placeholderImage: placeHolderImage,
                             options: indexPath == nil ? .highPriority : SDWebImageOptions.avoidAutoSetImage,
                             context: nil,
                             progress: nil,
                             completed: { (image: UIImage?, error: Error?, SDImageCacheType, url: URL?) in
                                if let i = image {
                                    if let data = i.pngData() {
                                        try? data.write(to: localFileURL, options: Data.WritingOptions.atomic)
                                    }
                                }
                                callback?(image, indexPath, error)
                             })
        }
    }
    
    func getImage(url: URL, placeholderImage: UIImage? = nil, shouldShowFullScreenProgrss: Bool = false, callback: ((_ success: Bool, _ url: URL?, _ image: UIImage?) -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            let tempDirectoyURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            let path = tempDirectoyURL.appendingPathComponent(url.lastPathComponent)
            
            let fileManger = FileManager.default
            let isFileExist = fileManger.fileExists(atPath: path.path)
            if !isFileExist {
                if shouldShowFullScreenProgrss {
                    DispatchQueue.main.async {
                        //Utils.showProgress()
                    }
                }
                self.sd_cancelCurrentImageLoad()
                self.sd_setImage(with: url, placeholderImage: placeholderImage, options: SDWebImageOptions.lowPriority) { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, url: URL?) in
                    DispatchQueue.global(qos: .background).async {
                        if(image != nil && url != nil) {
                            let data = image!.pngData()!
                            let _ = try? data.write(to: path)
                        }
                        DispatchQueue.main.async {
                            //Utils.dismissProgress()
                            callback?(image != nil, url, image)
                        }
                    }
                }
            }
            else {
                let data = try? Data(contentsOf: path)
                let image = data != nil ? UIImage(data: data!) : nil
                DispatchQueue.main.async {
                    callback?(image != nil, url, image)
                }
            }
        }
    }
}

extension PHAsset {
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
    
    func getAssetSizeInMB(completion: @escaping (Double) -> Void) {
        let resources = PHAssetResource.assetResources(for: self) // your PHAsset
        var sizeOnDisk: Double = 0
        if let resource = resources.first {
            let unsignedInt64 = resource.value(forKey: "fileSize") as? CLong
            sizeOnDisk = Double(bitPattern: UInt64(unsignedInt64!))
            completion(sizeOnDisk)
        }
    }
}
