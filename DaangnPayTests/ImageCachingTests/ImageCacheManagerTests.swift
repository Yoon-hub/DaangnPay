//
//  ImageCachingTests.swift
//  DaangnPayTests
//
//  Created by 최윤제 on 6/15/24.
//

import XCTest
@testable import DaangnPay
import UIKit

final class ImageCacheManagerTests: XCTestCase {
    
    var imageView: UIImageView!
    var imageCache: NSCache<NSString, UIImage>!
    
    override func setUp() {
        super.setUp()
        imageView = UIImageView()
        imageCache = ImageCacheManager.shared
        imageCache.removeAllObjects()
    }
    
    override func tearDown() {
        imageView = nil
        imageCache = nil
        super.tearDown()
    }

    func test_ImageCacheMemory() {
        
        // Given
        let testURL = URL(string: "https://daangnPay.com/image.png")!
        let testImage = UIImage(systemName: "star")!
        let cacheKey = NSString(string: testURL.absoluteString)
        
        // When
        imageCache.setObject(testImage, forKey: cacheKey)
        
        // Then
        XCTAssertNotNil(imageCache.object(forKey: cacheKey))
        XCTAssertEqual(imageCache.object(forKey: cacheKey), testImage)
    }
    
    func test_ImageLoadFromDiskCache() {
        
        // Given
        let testURL = URL(string: "https://daangnPay.com/image.png")!
        guard let testImage = UIImage(named: "imagePlaceholder") else {return}
        
        // When
        imageView.saveImageToDiskCache(image: testImage, for: testURL)
        let loadedImage = imageView.loadImageFromDiskCache(for: testURL)
        
        // Then
        XCTAssertNotNil(loadedImage)
        XCTAssertEqual(loadedImage?.pngData(), testImage.pngData())
    }
}
