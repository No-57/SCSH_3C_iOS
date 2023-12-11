//
//  ImageFactory.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/11.
//

import UIKit

class ImageFactory {
    
    ///
    /// heart-shape image ♥️
    ///
    static func generateHeartImage(size: CGSize, fillColor: UIColor, borderColor: UIColor, borderWidth: CGFloat) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            let drawPath = UIBezierPath()
            let heartWidth = size.width
            let heartHeight = size.height
            
            // Start at the bottom of the heart, halfway across
            drawPath.move(to: CGPoint(x: heartWidth / 2, y: heartHeight))
            
            // Create the left side of the heart
            drawPath.addCurve(to: CGPoint(x: 0, y: heartHeight / 4),
                              controlPoint1: CGPoint(x: heartWidth / 4, y: heartHeight * 3 / 4),
                              controlPoint2: CGPoint(x: 0, y: heartHeight / 2))
            
            // Create the top left curve
            drawPath.addArc(withCenter: CGPoint(x: heartWidth / 4, y: heartHeight / 4),
                            radius: heartWidth / 4,
                            startAngle: CGFloat.pi,
                            endAngle: 0,
                            clockwise: true)
            
            // Create the top right curve
            drawPath.addArc(withCenter: CGPoint(x: heartWidth * 3 / 4, y: heartHeight / 4),
                            radius: heartWidth / 4,
                            startAngle: CGFloat.pi,
                            endAngle: 0,
                            clockwise: true)
            
            // Create the right side of the heart
            drawPath.addCurve(to: CGPoint(x: heartWidth / 2, y: heartHeight),
                              controlPoint1: CGPoint(x: heartWidth, y: heartHeight / 2),
                              controlPoint2: CGPoint(x: heartWidth * 3 / 4, y: heartHeight * 3 / 4))
            
            // Fill and Stroke the path
            drawPath.close()
            fillColor.setFill()
            borderColor.setStroke()
            drawPath.lineWidth = borderWidth
            drawPath.fill()
            drawPath.stroke()
        }
    }
}
