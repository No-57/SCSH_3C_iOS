//
//  ExploreViewController.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/9.
//

import UIKit
import Combine

class ExploreViewController: UIViewController {
    
    private let viewModel: ExploreViewModel
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var cancellables = Set<AnyCancellable>()
    
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
        bindViewStateEvents()
        bindTransitionEvents()
        
        viewModel.viewDidLoad.send(())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear.send(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.send(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear.send(())
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
        
        collectionView.register(DistributorSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DistributorSectionHeaderView")
        
        collectionView.register(BoardSectionCollectionViewCell.self, forCellWithReuseIdentifier: "BoardSectionCollectionViewCell")
        collectionView.register(RecentSectionCollectionViewCell.self, forCellWithReuseIdentifier: "RecentSectionCollectionViewCell")
        collectionView.register(DistributorSectionCollectionViewCell.self, forCellWithReuseIdentifier: "DistributorSectionCollectionViewCell")
        collectionView.register(PopularSectionCollectionViewCell.self, forCellWithReuseIdentifier: "PopularSectionCollectionViewCell")
        collectionView.register(ExploreSectionCollectionViewCell.self, forCellWithReuseIdentifier: "ExploreSectionCollectionViewCell")
    }
    
    private func bindViewStateEvents() {
        // TODO: loading effect implement.
        viewModel.$themes
            .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
            .sink(receiveValue: { [weak self] _ in
                self?.collectionView.reloadData()
                self?.collectionView.layoutIfNeeded()
            })
            .store(in: &cancellables)
        
        viewModel.$boards
            .zip(viewModel.$firstBoardSectionIndex)
            .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
            .compactMap { [weak self] (boards, firstIndex) -> ([ExploreBoard], Int , BoardSectionCollectionViewCell)? in
                guard let index = self?.viewModel.themes.firstIndex(of: .Board) else {
                    return nil
                }
                
                guard let boardSectionCell = self?.getSection(indexPath: .init(item: 0, section: index)) as? BoardSectionCollectionViewCell else {
                    return nil
                }
                
                return (boards, firstIndex, boardSectionCell)

            }
            .sink(receiveValue: { [weak self] boards, firstIndex , boardSectionCell in
                guard let self = self else { return }
                
                boardSectionCell.setup(boards: boards, infiniteScrollItems: self.viewModel.infiniteScrollItems)
                boardSectionCell.scrollToItem(at: firstIndex, animated: false)
            })
            .store(in: &cancellables)
        
        viewModel.$boardSectionIsActive
            .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
            .compactMap { [weak self] isActive -> (Bool , BoardSectionCollectionViewCell)? in
                guard let index = self?.viewModel.themes.firstIndex(of: .Board) else {
                    return nil
                }
                
                guard let boardSectionCell = self?.getSection(indexPath: .init(item: 0, section: index)) as? BoardSectionCollectionViewCell else {
                    return nil
                }
                
                return (isActive, boardSectionCell)

            }
            .sink(receiveValue: { isActive, boardSectionCell in
                if isActive {
                    boardSectionCell.activate()
                } else {
                    boardSectionCell.inactivate()
                }
            })
            .store(in: &cancellables)
        
        
    }
    
    private func bindTransitionEvents() {
        viewModel.$route
            .compactMap {
                CoordinatorFacade.viewController(for: $0)
            }
            .sink(receiveValue: { [weak self] in
                self?.present($0, animated: true)
            })
            .store(in: &cancellables)
    }
    
    private func getSection(indexPath: IndexPath) -> UICollectionViewCell? {
        collectionView.cellForItem(at: indexPath)
    }
}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.themes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.themes[section] {
        case .Board, .Recent, .Distributor, .Popular:
            return 1
        default:
            return 15
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch viewModel.themes[section] {
        case .Board:
            return .zero

        default:
            return .init(top: 10, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        switch viewModel.themes[section] {
        case .Distributor:
            return CGSize(width: collectionView.frame.width, height: 50)

        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch viewModel.themes[indexPath.section] {
        case .Board:
            return CGSize(width: collectionView.bounds.width, height: 220)
            
        case .Recent:
            return CGSize(width: collectionView.bounds.width, height: 200)

        case .Distributor:
            return CGSize(width: collectionView.bounds.width, height: 350)

        case .Popular:
            return CGSize(width: collectionView.bounds.width, height: 150)

        default:
            return CGSize(width: collectionView.bounds.width / 2 - 10, height: 200)
        }
    }
}

extension ExploreViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        switch viewModel.themes[indexPath.section] {
        case .Distributor:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DistributorSectionHeaderView", for: indexPath) as! DistributorSectionHeaderView
            return headerView
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch viewModel.themes[indexPath.section] {
        case .Board:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardSectionCollectionViewCell", for: indexPath) as! BoardSectionCollectionViewCell
            cell.setup(boards: viewModel.boards, infiniteScrollItems: viewModel.infiniteScrollItems)
            cell.delegate = self
            return cell
            
        case .Recent:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentSectionCollectionViewCell", for: indexPath) as! RecentSectionCollectionViewCell
            return cell
            
        case .Distributor:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DistributorSectionCollectionViewCell", for: indexPath) as! DistributorSectionCollectionViewCell
            cell.setup(distributors: viewModel.distributors)
            cell.delegate = self
            return cell
            
        case .Popular:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularSectionCollectionViewCell", for: indexPath) as! PopularSectionCollectionViewCell
            return cell
            
        case .Explore:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExploreSectionCollectionViewCell", for: indexPath) as! ExploreSectionCollectionViewCell
            cell.contentView.backgroundColor = .blue
            return cell
        }
    }
}

protocol ExploreViewControllerDelegate: AnyObject {
    func boardCellDidTap(board: ExploreBoard)
    
    func distributorCellDidTap(distributor: Distributor)
    func distributorMainProductGestureDidTap(productId: String)
    func distributorSubProduct1GestureDidTap(productId: String)
    func distributorSubProduct2GestureDidTap(productId: String)
    func distributorLikeButtonDidTap(distributor: Distributor)
    func distributorExploreButtonDidTap(distributor: Distributor)
}

extension ExploreViewController: ExploreViewControllerDelegate {
    func boardCellDidTap(board: ExploreBoard) {
        viewModel.boardCellDidTap.send(board)
    }
    
    func distributorCellDidTap(distributor: Distributor) {
        viewModel.distributorCellDidTap.send(distributor)
    }

    func distributorMainProductGestureDidTap(productId: String) {
        viewModel.distributorMainProductGestureDidTap.send(productId)
    }

    func distributorSubProduct1GestureDidTap(productId: String) {
        viewModel.distributorSubProduct1GestureDidTap.send(productId)
    }

    func distributorSubProduct2GestureDidTap(productId: String) {
        viewModel.distributorSubProduct2GestureDidTap.send(productId)
    }
    
    func distributorLikeButtonDidTap(distributor: Distributor) {
        viewModel.distributorLikeButtonDidTap.send(distributor)
    }

    func distributorExploreButtonDidTap(distributor: Distributor) {
        viewModel.distributorExploreButtonDidTap.send(distributor)
    }
}
