//
//  ProductRepository.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/31.
//

import Foundation
import Combine
import Persistence
import Networking

protocol ProductRepositoryType {
    func getProducts(name: String?, isLatest: Bool) -> AnyPublisher<[Product], Error>
}

class ProductRepository: ProductRepositoryType {
    
    private let productMapper: ProductModelMapperType
    private let moyaNetworkFacade: MoyaNetworkFacadeType
    private let productCoreDataService: ProductCoreDataServiceType
    
    init(productMapper: ProductModelMapperType, moyaNetworkFacade: MoyaNetworkFacadeType, productCoreDataService: ProductCoreDataServiceType) {
        self.moyaNetworkFacade = moyaNetworkFacade
        self.productMapper = productMapper
        self.productCoreDataService = productCoreDataService
    }
    
    func getProducts(name: String?, isLatest: Bool) -> AnyPublisher<[Product], Error> {
        if isLatest {
            return fetchProducts(name: name)
                .flatMap { [weak self] _ -> AnyPublisher<[Product], Error>  in
                    guard let self = self else {
                        return Empty().eraseToAnyPublisher()
                    }
                    return self.getProducts(name: name)
                }
                .eraseToAnyPublisher()
        } else {
            return getProducts(name: name)
        }
    }
    
    private func getProducts(name: String?) -> AnyPublisher<[Product], Error> {
        productCoreDataService.get(name: name)
            .compactMap { [weak self] coreProducts -> [SCSH_3C_iOS.Product]? in
                self?.productMapper.transform(coreDataProducts: coreProducts)
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchProducts(name: String?) -> AnyPublisher<Void, Error> {
        moyaNetworkFacade.fetch(apiInterface: ProductApiInterface(name: name))
            .compactMap { [weak self] apiModel in
                self?.productMapper.transform(apiModel: apiModel)
            }
            .map { $0.map { $0.name } }
            .flatMap { [weak self] names -> AnyPublisher<Void, Error> in
                guard let self = self else { return Empty().eraseToAnyPublisher() }
                return self.productCoreDataService.save(names: names)
            }
            .eraseToAnyPublisher()
    }
}
