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
            if let imageURL = URL(string: article.articleImage) {
                do {
                    let imageData = try Data(contentsOf: imageURL)
                    let image = UIImage(data: imageData)
                    imageCache[article.articleTitle] = image
                    return image
                } catch {
                    print("Error downloading image.")
                }
            }
        } else {
            return imageCache[article.articleTitle]
        }
        return nil
    }
    
}
