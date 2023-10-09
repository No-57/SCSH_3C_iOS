//
//  BodyCollectionViewCell.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/9.
//

import UIKit

class BodyCollectionViewCell: UICollectionViewCell {
    
    private let previousButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let centerButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let nextButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let transparentButtonsHeaderStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.alignment = .fill
        v.distribution = .fillProportionally
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    private let bodyView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // temp
    let titleLabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 18)
        return l
    }()
    
    private var currentIndexPath: IndexPath?
    weak var delegate: HomeViewContollerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderLayout()
        setupBodyLayout()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeaderLayout() {
        transparentButtonsHeaderStackView.addArrangedSubview(previousButton)
        transparentButtonsHeaderStackView.addArrangedSubview(centerButton)
        transparentButtonsHeaderStackView.addArrangedSubview(nextButton)
        contentView.addSubview(transparentButtonsHeaderStackView)

        NSLayoutConstraint.activate([
            transparentButtonsHeaderStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            transparentButtonsHeaderStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            transparentButtonsHeaderStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            transparentButtonsHeaderStackView.heightAnchor.constraint(equalToConstant: 50),
            
            previousButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor),
            previousButton.widthAnchor.constraint(equalTo: centerButton.widthAnchor, multiplier: 0.5)
        ])
    }

    private func setupBodyLayout() {
        contentView.addSubview(bodyView)
        
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: transparentButtonsHeaderStackView.bottomAnchor),
            bodyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        bodyView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupAction() {
        previousButton.addTarget(self, action: #selector(previousButtonDidTap), for: .touchUpInside)
        centerButton.addTarget(self, action: #selector(centerButtonDidTap), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func previousButtonDidTap() {
        guard let currentIndexPath = currentIndexPath else { return }
        let previousIndexPath = IndexPath(row: currentIndexPath.row - 1, section: currentIndexPath.section)
        
        delegate?.scrollBodyCollectionView(at: previousIndexPath, animated: true)
    }
    
    @objc
    private func centerButtonDidTap() {
        guard let currentIndexPath = currentIndexPath else { return }
        
        delegate?.scrollBodyCollectionView(at: currentIndexPath, animated: true)
    }
    
    @objc
    private func nextButtonDidTap() {
        guard let currentIndexPath = currentIndexPath else { return }
        let nextIndexPath = IndexPath(row: currentIndexPath.row + 1, section: currentIndexPath.section)
        
        delegate?.scrollBodyCollectionView(at: nextIndexPath, animated: true)
    }
    
    func update(title: String, indexPath: IndexPath) {
        titleLabel.text = title
        self.currentIndexPath = indexPath
    }
}
