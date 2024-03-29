//
//  BoardSectionCollectionViewCell.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/9.
//

import UIKit

class BoardSectionCollectionViewCell: UICollectionViewCell {

    private var boards: [ExploreBoard] = []
    
    // Infinite scroll items number.
    private var infiniteScrollItems = 1000
    
    // This timer interval determines how frequently the collectionView will automatically scroll to the next page.
    private let interval: TimeInterval = 5
    private var timer: Timer?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let pageControl = UIPageControl()
    private let nextButton = RoundedButton()
    private let previousButton = RoundedButton()
    private let hoverRecognizer = UIHoverGestureRecognizer()
    
    // Page Action
    private enum Action {
        case next // move to next page
        case back // back to previous page
    }
    
    weak var delegate: ExploreViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupCollectionView()
        setupPageControl()
        setupButtons()
        setupRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        // collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        // pageControl
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        // previousbutton
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(previousButton)
        NSLayoutConstraint.activate([
            previousButton.widthAnchor.constraint(equalToConstant: 30),
            previousButton.heightAnchor.constraint(equalToConstant: 30),
            previousButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            previousButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        // nextbutton
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 30),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nextButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: "BoardCollectionViewCell")
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = boards.count
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
    }
    
    private func setupButtons() {
        previousButton.backgroundColor = .black
        previousButton.alpha = 0
        previousButton.setTitle("<", for: .normal)
        previousButton.addTarget(self, action: #selector(previousButtonDidTap), for: .touchUpInside)

        nextButton.backgroundColor = .black
        nextButton.alpha = 0
        nextButton.setTitle(">", for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func nextButtonDidTap() {
        changePage(to: .next)
    }
    
    @objc
    private func previousButtonDidTap() {
        changePage(to: .back)
    }
    
    private func changePage(to action: Action) {
        var contentOffset = collectionView.contentOffset.x
        switch action {
        case .next:
            contentOffset += collectionView.bounds.width
        case .back:
            contentOffset -= collectionView.bounds.width
        }
        
        collectionView.setContentOffset(.init(x: contentOffset, y: collectionView.contentOffset.y) , animated: true)
    }
    
    private func setupRecognizer() {
        collectionView.addGestureRecognizer(hoverRecognizer)
        hoverRecognizer.addTarget(self, action: #selector(hoverRecognizerDidTrigger(_:)))
    }
    
    @objc
    private func hoverRecognizerDidTrigger(_ recognizer: UIHoverGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            previousButton.alpha = 0.3
            nextButton.alpha = 0.3
            break
        case .ended, .cancelled:
            previousButton.alpha = 0
            nextButton.alpha = 0
            break
        default:
            break
        }
    }
    
    private func turnOnTimer() {
        turnOffTimer()
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(nextButtonDidTap), userInfo: nil, repeats: true)
    }
    
    private func turnOffTimer() {
        timer?.invalidate()
        timer = nil
    }

    func setup(boards: [ExploreBoard], infiniteScrollItems: Int) {
        self.boards = boards
        self.infiniteScrollItems = infiniteScrollItems
        
        pageControl.numberOfPages = boards.count

        collectionView.reloadData()
    }

    func scrollToItem(at index: Int, animated: Bool) {
        collectionView.scrollToItem(at: .init(item: index, section: 0), at: .centeredHorizontally, animated: animated)
    }
    
    func activate() {
        turnOnTimer()
    }
    
    func inactivate() {
        turnOffTimer()
    }
}

extension BoardSectionCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !boards.isEmpty else { return }
        
        let itemWidth = collectionView.frame.width
        let currentItem = round(collectionView.contentOffset.x / itemWidth)
        
        // update page
        pageControl.currentPage = Int(currentItem) % boards.count
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        turnOffTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        turnOnTimer()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        infiniteScrollItems
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BoardCollectionViewCell else { return }
        delegate?.boardCellDidTap(board: cell.getBoard())
    }
}

extension BoardSectionCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BoardCollectionViewCell", for: indexPath) as! BoardCollectionViewCell

        guard !boards.isEmpty else {
            return cell
        }
        
        let index = indexPath.item % boards.count
        let board = boards[index]
        cell.setup(board: board)
        
        return cell
    }
}
