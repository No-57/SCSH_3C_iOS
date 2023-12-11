//
//  ProductExploreSectionHeaderView.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/11.
//

import UIKit

class ProductExploreSectionHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 18, weight: .bold)
        l.textColor = .black
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setup() {
        titleLabel.text = "每日新發現"
    }
}
