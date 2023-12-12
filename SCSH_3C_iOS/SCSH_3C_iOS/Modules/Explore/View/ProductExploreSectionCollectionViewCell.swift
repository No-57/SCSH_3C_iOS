//
//  ProductExploreSectionCollectionViewCell.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/9.
//

import UIKit
import Kingfisher

class ProductExploreSectionCollectionViewCell: UICollectionViewCell {
    
    private let productImageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let likeButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        
        let imageSize = CGSize(width: 20, height: 20)
        let normalImage = ImageFactory.generateHeartImage(size: imageSize,
                                                          fillColor: .clear,
                                                          borderColor: .white,
                                                          borderWidth: 1.5)

        let selctedImage = ImageFactory.generateHeartImage(size: imageSize,
                                                           fillColor: .red,
                                                           borderColor: .white,
                                                           borderWidth: 1.5)

        b.setImage(normalImage, for: .normal)
        b.setImage(selctedImage, for: .selected)
        
        return b
    }()
    
    private let productNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 16, weight: .bold)
        l.textColor = .black
        l.lineBreakMode = .byTruncatingTail
        l.numberOfLines = 2
        return l
    }()
    
    private let distributorNameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 16, weight: .regular)
        l.textColor = .gray
        l.lineBreakMode = .byTruncatingTail
        l.numberOfLines = 1
        return l
    }()

    private let specialPriceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .black
        l.numberOfLines = 1
        return l
    }()

    private let tagPriceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 14, weight: .regular)
        l.textColor = .lightGray
        l.numberOfLines = 1
        return l
    }()
    
    weak var delegate: ExploreViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(productImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(distributorNameLabel)
        contentView.addSubview(specialPriceLabel)
        contentView.addSubview(tagPriceLabel)
        
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            productImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            likeButton.widthAnchor.constraint(equalToConstant: 30),
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -5),
            likeButton.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: -10),
            
            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 5),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            distributorNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            distributorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            distributorNameLabel.bottomAnchor.constraint(equalTo: specialPriceLabel.topAnchor, constant: -10),
            
            specialPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            specialPriceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            tagPriceLabel.leadingAnchor.constraint(equalTo: specialPriceLabel.trailingAnchor, constant: 10),
            tagPriceLabel.bottomAnchor.constraint(equalTo: specialPriceLabel.bottomAnchor),
        ])
    }
    
    private func setupAction() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func likeButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    func setup(product: Product) {
        productImageView.kf.setImage(with: product.image, placeholder: UIImage(systemName: "photo.fill"))
        
        productNameLabel.text = product.name
        distributorNameLabel.text = product.distributor.name
        specialPriceLabel.text = "NT$ \(product.specialPrice)"
        tagPriceLabel.attributedText = NSAttributedString(
            string: "NT$ \(product.tagPrice)",
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        )
        
        likeButton.isSelected = product.isLiked
    }
}
