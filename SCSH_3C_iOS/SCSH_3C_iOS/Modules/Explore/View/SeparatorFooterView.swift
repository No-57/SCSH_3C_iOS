//
//  SepartorFooterView.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/11.
//
 
import UIKit

class SeparatorFooterView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
