//
//  DistributorCollectionViewCell.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/11/13.
//

import UIKit
import Kingfisher

class DistributorCollectionViewCell: UICollectionViewCell {
    
    private var distributor = Distributor(id: UUID().uuidString, name: "", description: "", brandImage: URL.temporaryDirectory, products: [])
    
    private let containerStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.alignment = .fill
        v.distribution = .fill
        return v
    }()
    
    private let topContainerStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.distribution = .equalSpacing
        v.spacing = 3
        return v
    }()
    
    private let mainProductImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        return v
    }()
    
    private let subProductImagesContainerStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.distribution = .fillEqually
        v.spacing = 3
        return v
    }()

    private let subProductImageView_1 = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        return v
    }()

    private let subProductImageView_2 = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        return v
    }()
    
    private let bottomContainerView = {
        let v = CardBorderedView(frame: .zero, corners: [.bottomLeft, .bottomRight], cornerRadius: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let brandImageView = {
       let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let nameLabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .boldSystemFont(ofSize: 18)
        l.textColor = .black
        return l
    }()

    private let detailLabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = .systemFont(ofSize: 14)
        l.textColor = .gray
        return l
    }()

    private let exploreButton = {
        var attributedString = AttributedString("探索")
        attributedString.font = .systemFont(ofSize: 14, weight: .regular)

        var config = UIButton.Configuration.plain()
        config.attributedTitle = attributedString
        config.baseForegroundColor = .black
        config.baseBackgroundColor = .white
        config.background.strokeColor = .lightGray
        config.background.strokeWidth = 1
        
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    private let likeButton = {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .white
        config.background.strokeColor = .lightGray
        config.background.strokeWidth = 1
        
        let targetSize = CGSize(width: 16, height: 16)
        let heartFillImage = UIImage(systemName: "heart.fill")?.resize(targetSize: targetSize)?.withRenderingMode(.alwaysTemplate)
        
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.tintColor = .lightGray
        b.setImage(heartFillImage, for: .normal)
        b.setImage(heartFillImage, for: .selected)
        return b
    }()
    
    private let mainProductTapGestureRecognizer = UITapGestureRecognizer()
    private let subProduct1TapGestureRecognizer = UITapGestureRecognizer()
    private let subProduct2tapGestureRecognizer = UITapGestureRecognizer()
    
    weak var delegate: ExploreViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupLayout() {
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerStackView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            containerStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])

        containerStackView.addArrangedSubview(topContainerStackView)
        containerStackView.addArrangedSubview(bottomContainerView)
        
        topContainerStackView.addArrangedSubview(mainProductImageView)
        topContainerStackView.addArrangedSubview(subProductImagesContainerStackView)

        NSLayoutConstraint.activate([
            mainProductImageView.widthAnchor.constraint(equalTo: subProductImagesContainerStackView.widthAnchor, multiplier: 2),
            mainProductImageView.heightAnchor.constraint(equalTo: mainProductImageView.widthAnchor, multiplier: 1.2),
        ])

        subProductImagesContainerStackView.addArrangedSubview(subProductImageView_1)
        subProductImagesContainerStackView.addArrangedSubview(subProductImageView_2)
        
        bottomContainerView.addSubview(brandImageView)
        bottomContainerView.addSubview(nameLabel)
        bottomContainerView.addSubview(detailLabel)
        bottomContainerView.addSubview(exploreButton)
        bottomContainerView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            brandImageView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 10),
            brandImageView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 10),
            brandImageView.widthAnchor.constraint(equalToConstant: 50),
            brandImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: brandImageView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: brandImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -10),
            
            detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            exploreButton.leadingAnchor.constraint(equalTo: brandImageView.leadingAnchor),
            exploreButton.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -8),
            exploreButton.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor, constant: -10),
            exploreButton.heightAnchor.constraint(equalTo: likeButton.heightAnchor),
            
            likeButton.heightAnchor.constraint(equalToConstant: 30),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor, multiplier: 2),
            likeButton.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: exploreButton.bottomAnchor),
        ])
    }
    
    private func setupAction() {
        likeButton.addTarget(self, action: #selector(likeButtonDidTap), for: .touchUpInside)
        exploreButton.addTarget(self, action: #selector(exploreButtonDidTap), for: .touchUpInside)
        
        mainProductImageView.addGestureRecognizer(mainProductTapGestureRecognizer)
        subProductImageView_1.addGestureRecognizer(subProduct1TapGestureRecognizer)
        subProductImageView_2.addGestureRecognizer(subProduct2tapGestureRecognizer)
        
        mainProductTapGestureRecognizer.addTarget(self, action: #selector(mainProductImageDidTap))
        subProduct1TapGestureRecognizer.addTarget(self, action: #selector(subProduct1ImageDidTap))
        subProduct2tapGestureRecognizer.addTarget(self, action: #selector(subProduct2ImageDidTap))
    }
    
    @objc
    private func likeButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        sender.tintColor = sender.isSelected ? .red : .lightGray
        
        delegate?.distributorLikeButtonDidTap(distributor: distributor)
    }
    
    @objc
    private func exploreButtonDidTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        delegate?.distributorExploreButtonDidTap(distributor: distributor)
    }
    
    @objc
    private func mainProductImageDidTap() {
        guard let productId = distributor.products.first?.id else { return }
        
        delegate?.distributorMainProductGestureDidTap(productId: productId)
    }

    @objc
    private func subProduct1ImageDidTap() {
        guard distributor.products.count > 1 else { return }

        delegate?.distributorSubProduct2GestureDidTap(productId: distributor.products[1].id)
    }

    @objc
    private func subProduct2ImageDidTap() {
        guard let productId = distributor.products.last?.id else { return }
        
        delegate?.distributorSubProduct2GestureDidTap(productId: productId)
    }
    
    private func setupProductImages() {
        var mainProductImage: URL?
        var subProductImage_1: URL?
        var subProductImage_2: URL?
        
        for (index, product) in self.distributor.products.enumerated() {
            switch index {
            case 0:
                mainProductImage = product.image
                
            case 1:
                subProductImage_1 = product.image

            case 2:
                subProductImage_2 = product.image
                
            default:
                break
            }
        }
        
        mainProductImageView.kf.setImage(with: mainProductImage, placeholder: UIImage(systemName: "photo.fill"))
        subProductImageView_1.kf.setImage(with: subProductImage_1, placeholder: UIImage(systemName: "photo.fill"))
        subProductImageView_2.kf.setImage(with: subProductImage_2, placeholder: UIImage(systemName: "photo.fill"))
    }
    
    func setup(distributor: Distributor) {
        self.distributor = distributor
        
        setupProductImages()
        
        brandImageView.kf.setImage(with: self.distributor.brandImage, placeholder: UIImage(systemName: "photo.fill"))
        
        nameLabel.text = self.distributor.name
        detailLabel.text = self.distributor.description
        
        // TODO: add like data.
        likeButton.isSelected = false
    }
}
