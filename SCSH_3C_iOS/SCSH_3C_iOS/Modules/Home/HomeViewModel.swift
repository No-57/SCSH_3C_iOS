//
//  HomeViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var subjects: [String] = ["AAA", "BBB", "CCC", "DDD", "EEE", "FFF", "GGG", "HHH", "III", "JJJ"]
    @Published var indexPath: IndexPath = .init(item: 0, section: 0)

    // MARK: Input
    let viewDidAppear = PassthroughSubject<Int, Error>()

    // TODO: remove legacy code
    @Published var productNames: [String] = []
    let productCellDidTap = PassthroughSubject<String, Error>()
    let refreshButtonDidTap = PassthroughSubject<Void, Error>()
    let refreshControlDidTrigger = PassthroughSubject<Void, Error>()
    let searchTextDidChange = PassthroughSubject<String?, Error>()
    
    private let coordinator: HomeCoordinatorType
    private let productRepository: ProductRepositoryType
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: HomeCoordinatorType, productRepository: ProductRepositoryType) {
        self.productRepository = productRepository
        self.coordinator = coordinator
        
        bindEvents()
    }
    
    private func bindEvents() {
        viewDidAppear
            .compactMap { [weak self] infinitScrollItems -> IndexPath? in
                guard let self = self else { return nil }
                
                let firstItem = (infinitScrollItems / 2) - (infinitScrollItems / 2 % self.subjects.count)
                return IndexPath(item: firstItem, section: 0)
            }
            .sink { _ in
                print("something went wrong in viewDidAppear")
            } receiveValue: { [weak self] indexPath in
                self?.indexPath = indexPath
            }
            .store(in: &cancellables)
        
        viewDidAppear
            .sink { _ in
                print("something went wrong in viewDidAppear")
            } receiveValue: { [weak self] _ in
                self?.coordinator.presentNotificationPermissionDailog() { _ in }
            }
            .store(in: &cancellables)
        
        // TODO: remove legacy code
        productCellDidTap
            .sink { _ in
                print("something went wrong in productCellDidTap")
            } receiveValue: { [weak self] name in
                self?.coordinator.addNotification(title: name)
            }
            .store(in: &cancellables)
            
        
        Publishers.MergeMany(refreshControlDidTrigger, refreshButtonDidTap)
            .flatMap { [weak self] _ -> AnyPublisher<[Product], Error> in
                guard let self = self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                return self.productRepository.getProducts(name: nil, isLatest: true)
            }
            .map { $0.map { $0.name } }
            .sink { completion in
                print("something went wrong in viewOnAppear")
            } receiveValue: { [weak self] names in
                self?.productNames = names
            }
            .store(in: &cancellables)

        
        searchTextDidChange
            .flatMap { [weak self] searchText -> AnyPublisher<[Product], Error> in
                guard let self = self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                return self.productRepository.getProducts(name: searchText, isLatest: false)
            }
            .map { $0.map { $0.name } }
            .sink { completion in
                print("something went wrong in searchButtonDidTap")
            } receiveValue: { [weak self] names in
                self?.productNames = names
            }
            .store(in: &cancellables)
    }
}
