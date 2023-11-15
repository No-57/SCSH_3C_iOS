//
//  CardBorderedView.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/11/13.
//

import UIKit

class CardBorderedView: UIView {

    private let corners: UIRectCorner
    private let cornerRadius: CGFloat
    private let borderLayer = CAShapeLayer()
    
    init(frame: CGRect, corners: UIRectCorner, cornerRadius: CGFloat) {
        self.corners = corners
        self.cornerRadius = cornerRadius
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        borderLayer.path = path.cgPath
    }
    
    private func setup() {
        layer.addSublayer(borderLayer)
        borderLayer.fillColor = nil
        borderLayer.strokeColor = UIColor.lightGray.cgColor
        borderLayer.lineWidth = 1
    }
}

