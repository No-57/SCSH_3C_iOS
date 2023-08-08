//
//  HomeViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var productNames: [String] = []

    let viewDidAppear = PassthroughSubject<Void, Error>()
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
        Publishers.MergeMany(viewDidAppear, refreshControlDidTrigger, refreshButtonDidTap)
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
