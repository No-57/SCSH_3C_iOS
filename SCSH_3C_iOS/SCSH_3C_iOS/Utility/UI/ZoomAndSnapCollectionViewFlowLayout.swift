//
//  ZoomAndSnapCollectionViewFlowLayout.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/11.
//

import UIKit

class ZoomAndSnapCollectionViewFlowLayout: UICollectionViewFlowLayout {
    // Threshold for activating the zoom animation, based on the distance from the center.
    let activeDistance: CGFloat = 200
    
    let zoomRatio: CGFloat = 0.3
    let hightLightAlpha: CGFloat = 0.5
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect)?.compactMap({ $0.copy() as? UICollectionViewLayoutAttributes }) else {
            return nil
        }
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.frame.size)

        // Make the cells be zoomed when they reach the center of the screen
        for layoutAttribute in layoutAttributes where layoutAttribute.frame.intersects(visibleRect) {
            let distance = visibleRect.midX - layoutAttribute.center.x
            let transformPrecentage = distance / activeDistance

            if distance.magnitude < activeDistance {
                let zoom = 1 + zoomRatio * (1 - transformPrecentage.magnitude)
                layoutAttribute.transform3D = CATransform3DMakeScale(zoom, zoom, 1)
                layoutAttribute.zIndex = Int(zoom.rounded())
                
                if let cell = collectionView.cellForItem(at: layoutAttribute.indexPath) as? HeaderCollectionViewCell {
                    cell.hightLightTitle(alpha: hightLightAlpha * (1 - transformPrecentage.magnitude))
                }
            }
        }

        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        // Invalidate layout so that every cell get a chance to be zoomed when it reaches the center of the screen
        return true
    }
}
