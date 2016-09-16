//
//  ImageDownloader.swift
//  RSSFeedr
//
//  Created by Sau Chung Loh on 9/15/16.
//  Copyright © 2016 Matthew Loh. All rights reserved.
//

import UIKit

class ImageDownloader {
    static var imageCache = [String: UIImage]()
    
    class func downloadImage(article: Article) -> UIImage? {
        if imageCache[article.articleTitle] == nil {
            if let imageURL = NSURL(string: article.articleImage),
                let imageData = NSData(contentsOfURL: imageURL),
                let image = UIImage(data: imageData)  {
                //        var size = determineProfileImageSize()
                //       let resizedImage = ImageResizer.resizeImage(image, size: size)
                imageCache[article.articleTitle] = image
                return image
            }
        } else {
            return imageCache[article.articleTitle]
        }
        return nil
    }
}