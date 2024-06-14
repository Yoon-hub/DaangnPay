//
//  ImageCacheManager.swift
//  DaangnPay
//
//  Created by 최윤제 on 6/14/24.
//

import UIKit

final class ImageCacheManager {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}


extension UIImageView {
    func loadImage(url: URL, imagePlaceHolder: UIImage? = nil) {
        
        let imageCache = ImageCacheManager.shared
        
        if let imagePlaceHolder { self.image = imagePlaceHolder }

        // Check if the image is cached in memory
        let cacheKey = NSString(string: url.absoluteString)
        if let cachedImage = imageCache.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        // Check if the image is cached on disk
        if let cachedImage = loadImageFromDiskCache(for: url) {
            self.image = cachedImage
            imageCache.setObject(cachedImage, forKey: cacheKey)
            return
        }

        // Download image if not cached
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let downloadedImage = UIImage(data: data) else {
                print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Cache the image in memory
            imageCache.setObject(downloadedImage, forKey: cacheKey)

            // Cache the image on disk
            self.saveImageToDiskCache(image: downloadedImage, for: url)

            // Update UIImageView on the main thread
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }.resume()
    }

    private func loadImageFromDiskCache(for url: URL) -> UIImage? {
        let fileManager = FileManager.default
        let cacheDirectory = getCacheDirectory()
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)

        if fileManager.fileExists(atPath: filePath.path),
           let data = try? Data(contentsOf: filePath),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }

    private func saveImageToDiskCache(image: UIImage, for url: URL) {
        let cacheDirectory = getCacheDirectory()
        let filePath = cacheDirectory.appendingPathComponent(url.lastPathComponent)

        if let data = image.pngData() {
            try? data.write(to: filePath)
        }
    }

    private func getCacheDirectory() -> URL {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return cacheDirectory
    }
}
