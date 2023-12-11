//
//  TopAlignedCollectionViewFlowLayout.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/11.
//

import UIKit

class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        scrollDirection = .horizontal
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        scrollDirection = .horizontal
    }
    
    //  Default:
    //  --------------
    //
    //  [] [] [] [] []
    //  [] [] [] [] []
    //
    //  --------------
    //
    //  After:
    //  --------------
    //  [] [] [] [] []
    //  [] [] [] [] []
    //
    //
    //  --------------
    //
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var topMargin = sectionInset.top
        var maxY: CGFloat = -1.0
        var rowNumber: CGFloat = 0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                topMargin = sectionInset.top + (layoutAttribute.frame.height + minimumInteritemSpacing) * rowNumber
                rowNumber += 1
            }

            layoutAttribute.frame.origin.y = topMargin

            maxY = max(layoutAttribute.frame.maxY, maxY)
        }

        return attributes
    }
}
