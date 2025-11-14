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
    
    static func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = url.absoluteString as NSString
        
        if let cachedImage = cache.object(forKey: cacheKey) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
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
extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        if let placeholder = placeholder {
            self.image = placeholder
        }
        
        ImageLoaderService.loadImage(from: url) { [weak self] image in
            self?.image = image ?? placeholder
        }
    }
}
