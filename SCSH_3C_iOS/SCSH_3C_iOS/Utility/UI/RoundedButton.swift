//
//  RoundedButton.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/12.
//

import UIKit

class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}
