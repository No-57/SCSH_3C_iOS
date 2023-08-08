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
            .flatMap { [weak self] _ -> AnyPublisher<[Product], Error> in
                guard let self = self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                return self.productRepository.getProducts(name: nil, isLatest: true)
            }
            .sink { completion in
                print("something went wrong in viewOnAppear")
            } receiveValue: { [weak self] products in
                self?.productNames = products.map { product in product.name } // temp
            }
            .store(in: &cancellables)

        
        searchTextDidChange
            .flatMap { [weak self] searchText -> AnyPublisher<[Product], Error> in
                guard let self = self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                return self.productRepository.getProducts(name: searchText, isLatest: false)
            }
            .sink { completion in
                print("something went wrong in searchButtonDidTap")
            } receiveValue: { [weak self] products in
                self?.productNames = products.map { product in product.name } // temp
            }
            .store(in: &cancellables)
    }
}
