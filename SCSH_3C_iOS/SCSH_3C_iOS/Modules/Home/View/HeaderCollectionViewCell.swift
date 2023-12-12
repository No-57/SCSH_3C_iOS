//
//  HeaderCollectionViewCell.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/8.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    private let titleLabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .black
        l.alpha = 0.3
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func update(theme: HomeTheme) {
        switch theme {
        case .Explore:
            titleLabel.text = "探索"
        case .Subject:
            titleLabel.text = "主題館"
        case .GamePoint:
            titleLabel.text = "點數卡"
        case .Product3C:
            titleLabel.text = "3C用品"
        case .Special:
            titleLabel.text = "特殊企劃"
        case .Distributor(let name):
            titleLabel.text = name
        }
    }
    
    func hightLightTitle(alpha: CGFloat) {
        titleLabel.alpha = 0.3 + alpha
    }
}
