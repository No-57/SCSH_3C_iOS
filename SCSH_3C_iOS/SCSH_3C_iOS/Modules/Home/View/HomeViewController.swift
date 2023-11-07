//
//  HomeViewController.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/6.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    
    private let headerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: ZoomAndSnapFlowLayout())
    private let bodyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // The scroll (per page) offset ratio between header and body
    private let headerToBodyScrollRatio: CGFloat = 2.0 / 5.0

    private var cancellables = Set<AnyCancellable>()
    
    private enum HomeViewControllerError: Error {
        case uiNotLoaded
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionViews()
        bindEvents()
        
        viewModel.viewDidLoad.send(())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear.send(())
    }
    
    private func setupCollectionViews() {
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: "HeaderCollectionViewCell")
        
        bodyCollectionView.delegate = self
        bodyCollectionView.dataSource = self
        bodyCollectionView.register(BodyCollectionViewCell.self, forCellWithReuseIdentifier: "BodyCollectionViewCell")
    }
    
    private func setupLayout() {
        // header
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        headerCollectionView.isUserInteractionEnabled = false
        view.addSubview(headerCollectionView)
        (headerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        
        NSLayoutConstraint.activate([
            headerCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            headerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerCollectionView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // body
        bodyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bodyCollectionView.isPagingEnabled = true
        bodyCollectionView.backgroundColor = .clear
        view.addSubview(bodyCollectionView)
        (bodyCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        
        NSLayoutConstraint.activate([
            bodyCollectionView.topAnchor.constraint(equalTo: headerCollectionView.topAnchor),
            bodyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bodyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bodyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindEvents() {
        viewModel.themes
            .zip(viewModel.firstHeaderIndex)
            .throttle(for: .milliseconds(100), scheduler: DispatchQueue.main, latest: true)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _, firstIndex in
                self?.headerCollectionView.reloadData()
                self?.bodyCollectionView.reloadData()
                
                self?.headerCollectionView.scrollToItem(at: .init(item: firstIndex, section: 0), at: .left, animated: false)
                self?.bodyCollectionView.scrollToItem(at: .init(item: firstIndex, section: 0), at: .left, animated: false)
            }
            .store(in: &cancellables)
        
        viewModel.hightLightHeaderIndex
            .receive(on: DispatchQueue.main)
            .tryCompactMap { [weak self] index -> HeaderCollectionViewCell? in
                guard let cell = self?.headerCollectionView.cellForItem(at: .init(item: index, section: 0)) as? HeaderCollectionViewCell else {
                    throw HomeViewControllerError.uiNotLoaded
                }
                return cell
            }
            .retry(1)
            .sink { _ in
                print("something went wrong in $hightLightHeaderIndexPath")
            } receiveValue: { [weak self] headerCell in
                self?.hightLightHeaderTitle(cell: headerCell)
            }
            .store(in: &cancellables)
    }
    
    private func hightLightHeaderTitle(cell: HeaderCollectionViewCell) {
        // cancel hightlight others
        for visibleCell in headerCollectionView.visibleCells.filter({ $0 is HeaderCollectionViewCell }) as? [HeaderCollectionViewCell] ?? [] {
            visibleCell.hightLightTitle(alpha: 0)
        }

        cell.hightLightTitle(alpha: 0.7)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    ///
    /// The layout of Header & Body.
    ///
    /// Header
    ///         []  []  []
    /// Body
    ///         [][][][][]
    ///
    /// When the Body swips `5` blocks, the Header needs to swipe `2` blocks.
    ///
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == bodyCollectionView else { return }
        headerCollectionView.contentOffset.x = scrollView.contentOffset.x * self.headerToBodyScrollRatio
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == bodyCollectionView else { return }
        print("BodyCollectionView selected cell at \(indexPath.item)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.infinitScrollItems
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case headerCollectionView:
            return CGSize(width: collectionView.bounds.width / 5, height: collectionView.bounds.height / 2)
        case bodyCollectionView:
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        switch collectionView {
        case headerCollectionView:
            return collectionView.bounds.width / 5
        case bodyCollectionView:
            return 0
        default:
            return 0
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let themes = viewModel.themes.value

        switch collectionView {
        case headerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
            
            guard themes.count > 0 else {
                return cell
            }
            
            // get the actual index for themes array
            var index = indexPath.item % themes.count
            
            // Since one page contains three header cells, the primary cell should be centered on the page.
            if index == 0 {
                index = themes.count - 1
            } else {
                index -= 1
            }
            
            let theme = themes[index]
            
            cell.update(theme: theme)
            return cell
            
        case bodyCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyCollectionViewCell", for: indexPath) as! BodyCollectionViewCell
            
            guard themes.count > 0 else {
                return cell
            }
            
            cell.delegate = self
            
            // get the actual index for items array
            let index = indexPath.item % themes.count
            
            let theme = themes[index]
            
            switch theme {
            case .Explore:
                let exploreVC = ExploreViewController(viewModel: ExploreViewModel())
                cell.setup(embeddedviewController: exploreVC, to: self, indexPath: indexPath)
                
            default:
                cell.setup(indexPath: indexPath)
            }
            
            return cell
            
        default:
            return .init()
        }
    }
}

protocol HomeViewContollerDelegate: AnyObject {
    func scrollBodyCollectionView(at: IndexPath, animated: Bool)
}

extension HomeViewController: HomeViewContollerDelegate {
    func scrollBodyCollectionView(at: IndexPath, animated: Bool) {
        bodyCollectionView.scrollToItem(at: at, at: .left, animated: animated)
    }
}
