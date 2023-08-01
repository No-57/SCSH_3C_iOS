//
//  HomeViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var productNames: [String] = []

    let searchButtonDidTap = PassthroughSubject<Void, Error>()
    
    private let coordinator: HomeCoordinatorType
    private let productRepository: ProductRepositoryType
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: HomeCoordinatorType, productRepository: ProductRepositoryType) {
        self.productRepository = productRepository
        self.coordinator = coordinator
        
        bindEvents()
    }
    
    private func bindEvents() {
        searchButtonDidTap
            .compactMap { [weak self] _ in
                self?.searchText
            }
            .flatMap { [weak self] searchText -> AnyPublisher<[Product], Error> in
                guard let self = self else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                return self.productRepository.getProducts(name: searchText, isLatest: true)
            }
            .sink { completion in
                print("something went wrong")
            } receiveValue: { [weak self] products in
                self?.productNames = products.map { product in product.name } // temp
            }
            .store(in: &cancellables)
    }
}
