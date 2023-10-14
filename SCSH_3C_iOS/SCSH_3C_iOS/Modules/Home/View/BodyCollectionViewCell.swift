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
    
    private var currentIndexPath: IndexPath?
    private weak var embeddedViewController: UIViewController?
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Remove the view controller when the cell is being reused
        embeddedViewController?.willMove(toParent: nil)
        embeddedViewController?.view.removeFromSuperview()
        embeddedViewController?.removeFromParent()
        embeddedViewController = nil
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
    
    func setup(embeddedviewController: UIViewController, to parentViewController: UIViewController, indexPath: IndexPath) {
        setup(indexPath: indexPath)
        
        // Store the reference to the view controller
        self.embeddedViewController = embeddedviewController

        // Add the view controller as a child view controller
        parentViewController.addChild(embeddedviewController)

        // Set the frame of the view controller's view
        embeddedviewController.view.frame = self.bodyView.bounds

        // Add the view controller's view to the cell's content view
        self.bodyView.addSubview(embeddedviewController.view)

        // Complete the addition
        embeddedviewController.didMove(toParent: parentViewController)
    }
    
    func setup(indexPath: IndexPath) {
        self.currentIndexPath = indexPath
    }
}
