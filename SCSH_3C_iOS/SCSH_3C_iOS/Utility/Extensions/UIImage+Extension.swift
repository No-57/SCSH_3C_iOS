//
//  UIImage+Extension.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/11/13.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        let size = size
        
        let widthRatio  = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determine the scale factor that preserves aspect ratio
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Create an image context
        UIGraphicsBeginImageContextWithOptions(scaledImageSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: scaledImageSize))
        
        // Capture the scaled image from the context
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}

