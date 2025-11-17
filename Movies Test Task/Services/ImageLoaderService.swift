//
//  NetworkImageDownload.swift
//  Movies Test Task
//
//  Created by Mixon on 13.11.2025.
//

import Foundation
import UIKit

class ImageLoaderService {
    
    private static let cache = NSCache<NSString, UIImage>()
    
    
    static func loadImageTask(from url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask? {
        let cacheKey = url.absoluteString as NSString
        print("cacheKey", cacheKey)
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                print(cachedImage)
                completion(cachedImage)
            }
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let resizedImage = image.resizedToCellSize()
            if let compressedData = resizedImage.jpegData(compressionQuality: 0.5),
               let compressedImage = UIImage(data: compressedData) {
                
                cache.setObject(compressedImage, forKey: cacheKey)
                
                DispatchQueue.main.async {
                    print(compressedImage)
                    completion(compressedImage)
                }
            }
        }
        task.resume()
        return task
    }
    
    static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            _ = loadImageTask(from: url, completion: completion)
        }
    
    static func loadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: cacheKey),
           let imageData = cachedImage.pngData() {
            completion(imageData)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil else {
                completion(nil)
                return
            }
            
            
            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: cacheKey)
            }
            
            completion(data)
        }.resume()
    }
}
// MARK: - Extension UIImageView

private var associatedURLKey: UInt8 = 0
private var associatedTaskKey: UInt8 = 1
extension UIImageView {
    private var currentURL: URL? {
            get {
                return objc_getAssociatedObject(self, &associatedURLKey) as? URL
            }
            set {
                objc_setAssociatedObject(self, &associatedURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    
    private var currentTask: URLSessionDataTask? {
            get {
                return objc_getAssociatedObject(self, &associatedTaskKey) as? URLSessionDataTask
            }
            set {
                objc_setAssociatedObject(self, &associatedTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.currentURL = url
        print(url)
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        let task = ImageLoaderService.loadImageTask(from: url) { [weak self] image in
                
                    self?.currentTask = nil
                    
                    if self?.currentURL == url {
                        self?.image = image ?? placeholder
                    }
                }
                self.currentTask = task
    }
    
    func cancelImageLoad() {
            self.currentTask?.cancel()
            self.currentTask = nil
            self.currentURL = nil
    }
}

extension UIImage{
    func resizedToCellSize() -> UIImage {
            let targetWidth: CGFloat = 600
            let scaleFactor = targetWidth / self.size.width
            let targetHeight = self.size.height * scaleFactor
            let newSize = CGSize(width: targetWidth, height: targetHeight)
            
            let rect = CGRect(origin: .zero, size: newSize)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage ?? self
        }
}
