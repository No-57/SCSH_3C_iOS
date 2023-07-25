//
//  ContentViewModel.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/25.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var productNames: [String] = []

    let searchButtonDidTap = PassthroughSubject<Void, Error>()
    
    private let moyaNetworkService: MoyaNetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(moyaNetworkService: MoyaNetworkService = .shared) {
        self.moyaNetworkService = moyaNetworkService
        
        bindEvents()
    }
    
    private func bindEvents() {
        searchButtonDidTap
            .compactMap { [weak self] _ in
                self?.searchText
            }
            .flatMap { [weak self] searchText -> AnyPublisher<ProductApiInterface.OutputModel, Error> in
                if let self = self {
                    return self.moyaNetworkService.fetch(apiInterface: ProductApiInterface(name: searchText))
                } else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
            }
            .sink { completion in
                print("something went wrong")
            } receiveValue: { [weak self] model in
                self?.productNames = model.names
            }
            .store(in: &cancellables)
    }
}
