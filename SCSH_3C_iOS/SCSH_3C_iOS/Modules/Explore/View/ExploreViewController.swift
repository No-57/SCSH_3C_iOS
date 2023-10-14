//
//  ExploreViewController.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/9.
//

import UIKit
import Combine

class ExploreViewController: UIViewController {

    private enum SectionName: Int {
        case Board
        case Recent
        case Brand
        case Popular
        case Explore
    }
    
    private let viewModel: ExploreViewModel
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(viewModel: ExploreViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let cell = collectionView.cellForItem(at: .init(row: 0, section: 0)) as? BoardSectionCollectionViewCell {
            cell.setupInfiniteScroll()
        }
    }
    
    private func setupLayout() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical
        collectionView.register(BoardSectionCollectionViewCell.self, forCellWithReuseIdentifier: "BoardSectionCollectionViewCell")
        collectionView.register(RecentSectionCollectionViewCell.self, forCellWithReuseIdentifier: "RecentSectionCollectionViewCell")
        collectionView.register(BrandSectionCollectionViewCell.self, forCellWithReuseIdentifier: "BrandSectionCollectionViewCell")
        collectionView.register(PopularSectionCollectionViewCell.self, forCellWithReuseIdentifier: "PopularSectionCollectionViewCell")
        collectionView.register(ExploreSectionCollectionViewCell.self, forCellWithReuseIdentifier: "ExploreSectionCollectionViewCell")
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case SectionName.Board.rawValue, SectionName.Recent.rawValue, SectionName.Brand.rawValue, SectionName.Popular.rawValue:
            return 1
        default:
            return 15
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case SectionName.Board.rawValue:
            return CGSize(width: collectionView.bounds.width, height: 220)
            
        case SectionName.Recent.rawValue:
            return CGSize(width: collectionView.bounds.width, height: 200)

        case SectionName.Brand.rawValue:
            return CGSize(width: collectionView.bounds.width, height: 300)

        case SectionName.Popular.rawValue:
            return CGSize(width: collectionView.bounds.width, height: 150)

        default:
            return CGSize(width: collectionView.bounds.width / 2 - 10, height: 200)
        }
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case SectionName.Board.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardSectionCollectionViewCell", for: indexPath) as! BoardSectionCollectionViewCell
            return cell
            
        case SectionName.Recent.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSectionCollectionViewCell", for: indexPath) as! RecentSectionCollectionViewCell
            return cell
            
        case SectionName.Brand.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandSectionCollectionViewCell", for: indexPath) as! BrandSectionCollectionViewCell
            return cell
            
        case SectionName.Popular.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularSectionCollectionViewCell", for: indexPath) as! PopularSectionCollectionViewCell
            return cell
            
        case SectionName.Explore.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreSectionCollectionViewCell", for: indexPath) as! ExploreSectionCollectionViewCell
            cell.contentView.backgroundColor = .blue
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}
