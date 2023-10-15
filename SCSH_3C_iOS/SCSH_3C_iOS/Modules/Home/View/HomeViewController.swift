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
    
    // Infinite scroll items number.
    private let infinitScrollItems = 1000

    // The scroll (per page) offset ratio between header and body
    private let headerToBodyScrollRatio: CGFloat = 2.0 / 5.0

    private var cancellables = Set<AnyCancellable>()
    
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
        setupEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear.send(infinitScrollItems)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear.send(())
    }
    
    private func setupEvents() {
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        bodyCollectionView.delegate = self
        bodyCollectionView.dataSource = self
        
        viewModel.$firstHeaderIndexPath
            .receive(on: DispatchQueue.main)
            .sink { _ in
                print("something went wrong in $firstHeaderIndexPath")
            } receiveValue: { [weak self] indexPath in
                self?.headerCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
                self?.bodyCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            }
            .store(in: &cancellables)
        
        viewModel.$hightLightHeaderIndexPath
            .receive(on: DispatchQueue.main)
            .compactMap { [weak self] indexPath in
                self?.headerCollectionView.cellForItem(at: indexPath) as? HeaderCollectionViewCell
            }
            .sink { _ in
                print("something went wrong in $hightLightHeaderIndexPath")
            } receiveValue: { headerCell in
                headerCell.hightLightTitle(alpha: 0.7)
            }
            .store(in: &cancellables)
    }
    
    private func setupLayout() {
        // header
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        headerCollectionView.isUserInteractionEnabled = false
        view.addSubview(headerCollectionView)
        (headerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        headerCollectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: "HeaderCollectionViewCell")
        
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
        bodyCollectionView.register(BodyCollectionViewCell.self, forCellWithReuseIdentifier: "BodyCollectionViewCell")
        
        NSLayoutConstraint.activate([
            bodyCollectionView.topAnchor.constraint(equalTo: headerCollectionView.topAnchor),
            bodyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bodyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bodyCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        infinitScrollItems
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
        
        switch collectionView {
        case headerCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionViewCell", for: indexPath) as! HeaderCollectionViewCell
            
            // get the actual index for subjects array
            var index = indexPath.item % viewModel.subjects.count
            
            // Since one page contains three header cells, the primary cell should be centered on the page.
            if index == 0 {
                index = viewModel.subjects.count - 1
            } else {
                index -= 1
            }
            
            let subject = viewModel.subjects[index]
            
            cell.update(title: subject)
            return cell
            
        case bodyCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyCollectionViewCell", for: indexPath) as! BodyCollectionViewCell
            cell.delegate = self
            
            // get the actual index for items array
            let index = indexPath.item % viewModel.subjects.count
            
            let subject = viewModel.subjects[index]
            
            switch subject {
            case "Explore":
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
