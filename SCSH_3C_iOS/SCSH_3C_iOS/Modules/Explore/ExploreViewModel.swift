//
//  ExploreViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/10/9.
//

import Foundation
import Combine

class ExploreViewModel: ObservableObject {
    // Output
    @Published var themes: [ExploreTheme] = [.Board]
    
    // First display index at board collection view.
    @Published var firstBoardSectionIndex: Int = 0
    @Published var boardSectionIsActive = false
    @Published var boards: [ExploreBoard] = []
    
    @Published var distributors: [Distributor] = []
    
    @Published var products: [Product] = []
    private var currentPageAtProductExplore: Int = 0
    
    @Published var route = Route.none

    // Infinite scroll items number on Board section.
    let infiniteScrollItems = 1000

    // Input
    let viewDidLoad = PassthroughSubject<Void, Never>()
    let viewWillAppear = PassthroughSubject<Void, Never>()
    let viewDidAppear = PassthroughSubject<Void, Never>()
    let viewWillDisappear = PassthroughSubject<Void, Never>()
    
    let boardCellDidTap = PassthroughSubject<ExploreBoard, Never>()
    
    let distributorCellDidTap = PassthroughSubject<Distributor, Never>()
    let distributorMainProductGestureDidTap = PassthroughSubject<String, Never>()
    let distributorSubProduct1GestureDidTap = PassthroughSubject<String, Never>()
    let distributorSubProduct2GestureDidTap = PassthroughSubject<String, Never>()
    let distributorLikeButtonDidTap = PassthroughSubject<Distributor, Never>()
    let distributorExploreButtonDidTap = PassthroughSubject<Distributor, Never>()
    
    let productExploreCellDidTap = PassthroughSubject<Product, Never>()
    let porductExploreLikeButtonDidTap = PassthroughSubject<Product, Never>()
    let productExploreListDidScrollToThreshold = PassthroughSubject<Void, Never>()
    
    private let coordinator: ExploreCoordinatorType
    private let boardRepository: BoardRepositoryType
    private let themeRepository: ThemeRepositoryType
    private let distributorRepository: DistributorRepositoryType
    private let productRepository: ProductRepositoryType
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: ExploreCoordinatorType, boardRepository: BoardRepositoryType, themeRepository: ThemeRepositoryType, distributorRepository: DistributorRepositoryType, productRepository: ProductRepositoryType) {
        self.coordinator = coordinator
        self.boardRepository = boardRepository
        self.themeRepository = themeRepository
        self.distributorRepository = distributorRepository
        self.productRepository = productRepository
        
        bindExploreEvents()
        bindBoardEvents()
        bindDistributorEvents()
        bindProductExploreEvents()
        bindTransitionEvents()
    }

    private func bindExploreEvents() {
        viewDidLoad
            .flatMap { [weak self] _ -> AnyPublisher<([ExploreTheme], [ExploreBoard], [Distributor], [Product]), Error> in
                guard let self = self else {
                    return Empty<([ExploreTheme], [ExploreBoard], [Distributor], [Product]), Error>().eraseToAnyPublisher()
                }
                
                return self.themeRepository.getThemes(isLatest: true)
                    .combineLatest(self.boardRepository.getExploreBoards(isLatest: true),
                                   self.distributorRepository.getDistributors(isLatest: true),
                                   self.productRepository.getProducts(isLatest: false, page: 0))
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { _ in
                // TODO: Error handling
            }, receiveValue: { [weak self] (themes, boards, distributors, products) in
                self?.themes = themes
                self?.boards = boards
                self?.distributors = distributors
                self?.products = products
                self?.currentPageAtProductExplore = 0
            })
            .store(in: &cancellables)
    }
    
    private func bindBoardEvents() {
        viewWillAppear
            .map { true }
            .assign(to: \.boardSectionIsActive, on: self)
            .store(in: &cancellables)
        
        viewWillDisappear
            .map { false }
            .assign(to: \.boardSectionIsActive, on: self)
            .store(in: &cancellables)
        
        $boards.dropFirst()
            .map { [weak self] boards -> Int in
                guard let self = self, boards.count > 0 else {
                    return 0
                }

                return (self.infiniteScrollItems / 2) - ((self.infiniteScrollItems / 2) % boards.count)
            }
            .assign(to: \.firstBoardSectionIndex, on: self)
            .store(in: &cancellables)
        
        boardCellDidTap
            .compactMap(\.action)
            .sink(receiveValue: { [weak self] in
                self?.coordinator.requestWebNavigation(url: $0)
            })
            .store(in: &cancellables)
    }
    
    private func bindDistributorEvents() {
        // TODO: optimize it, use `scan` operator or else.
        distributorLikeButtonDidTap
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .flatMap { [weak self] distributor -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }

                guard distributor.isLiked else {
                    return self.distributorRepository.deleteLike(id: distributor.id).eraseToAnyPublisher()
                }

                return self.distributorRepository.addLike(id: distributor.id).eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { _ in
                // TODO: Error handling
            }, receiveValue: {})
            .store(in: &cancellables)
        
        distributorExploreButtonDidTap
            .merge(with: distributorCellDidTap)
            .map(\.id)
            .sink(receiveValue: { [weak self] in
                self?.coordinator.requestDistributorNavigation(id: String($0))
            })
            .store(in: &cancellables)
        
        distributorMainProductGestureDidTap
            .merge(with: distributorSubProduct1GestureDidTap, distributorSubProduct2GestureDidTap)
            .sink(receiveValue: { [weak self] in
                self?.coordinator.requestProductNavigation(id: $0)
            })
            .store(in: &cancellables)
    }
    
    private func bindProductExploreEvents() {
     
        productExploreCellDidTap
            .map(\.id)
            .sink(receiveValue: { [weak self] in
                self?.coordinator.requestProductNavigation(id: String($0))
            })
            .store(in: &cancellables)
        
        porductExploreLikeButtonDidTap
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .flatMap { [weak self] product -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }

                guard product.isLiked else {
                    // TODO: implement delete like
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }

                // TODO: implement add like
                return Empty<Void, Error>().eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { _ in
                // TODO: Error handling
            }, receiveValue: {})
            .store(in: &cancellables)
        
        productExploreListDidScrollToThreshold
            .compactMap { [weak self] _ -> Int? in
                guard let self = self else {
                    return nil
                }
                
                self.currentPageAtProductExplore += self.currentPageAtProductExplore
                
                return self.currentPageAtProductExplore
            }
            .flatMap { [weak self] page -> AnyPublisher<[Product], Error> in
                guard let self = self else {
                    return Empty<[Product], Error>().eraseToAnyPublisher()
                }
                
                return self.productRepository.getProducts(isLatest: true, page: self.currentPageAtProductExplore)
            } .sink(receiveCompletion: { _ in
                // TODO: Error handling
            }, receiveValue: { [weak self] products in
                self?.products.append(contentsOf: products)
            })
            .store(in: &cancellables)
            
    }

    private func bindTransitionEvents() {
        coordinator.navigate
            .assign(to: \.route, on: self)
            .store(in: &cancellables)
    }
}
