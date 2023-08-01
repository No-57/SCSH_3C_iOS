//
//  ProductRepository.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/31.
//

import Foundation
import Combine

protocol ProductRepositoryType {
    func getProducts(name: String, isLatest: Bool) -> AnyPublisher<[Product], Error>
}

class ProductRepository: ProductRepositoryType {
    
    private let productMapper: ProductModelMapperType
    private let moyaNetworkFacade: MoyaNetworkFacadeType
    
    init(productMapper: ProductModelMapperType, moyaNetworkFacade: MoyaNetworkFacadeType) {
        self.moyaNetworkFacade = moyaNetworkFacade
        self.productMapper = productMapper
    }
    
    func getProducts(name: String, isLatest: Bool) -> AnyPublisher<[Product], Error> {
        guard isLatest else {
            fatalError("Not support yet!!")
        }
        
        return moyaNetworkFacade.fetch(apiInterface: ProductApiInterface(name: name))
            .compactMap { [weak self] apiModel in
                self?.productMapper.transform(apiModel: apiModel)
            }
            .eraseToAnyPublisher()
    }
}
