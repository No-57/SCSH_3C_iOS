//
//  ProductRepositoryTests.swift
//  SCSH_3C_iOSTests
//
//  Created by 辜敬閎 on 2023/7/31.
//

import XCTest
import Combine
@testable import SCSH_3C_iOS
@testable import Persistence

final class ProductRepositoryTests: XCTestCase {

    var sut: ProductRepository!
    var cancellables = Set<AnyCancellable>()

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    ///
    /// Test Product datasource returns successfully.
    ///
    /// Expect:
    ///     1. `[`Product(name: `"iPhone14"`), Product(name: `"iPhone13 pro max"`)`]`
    ///
    /// Condition:
    ///     1. function parameters          -> name: `"iPhone"`, isLatest: `true`
    ///     2. MockProductMapper            -> `[`Product(name: `"iPhone14"`), Product(name: `"iPhone13 pro max"`)`]`
    ///     3. MockMoyaNetworkFacade        -> ProductApiModel(names: `[``"iPhone14"`, `"iPhone13 pro max"``]`)
    ///     4. MockProductCoreDataService   -> mockGetResult:  .success(`[`Product(`"iPhone14"`), Product(`"iPhone13 pro max""`)`]`)
    ///                                        mockSaveResult: .success
    ///
    func testGetProductsSuccessWithName() {
        // sut
        let mockProducts = [Product(name: "iPhone14"), Product(name: "iPhone13 pro max")]
        let mockProductApiResult: Result<ProductApiModel, Error> = .success(ProductApiModel(names: ["iPhone14", "iPhone13 pro max"]))
        let mockProductCoreData = makeMockCoreDataModel(names: ["iPhone14", "iPhone13 pro max"])

        let mockProductMapper = MockProductMapper(mockProducts: mockProducts)
        let moyaNetworkFacade = MockMoyaNetworkFacade(mockProductApiResult: mockProductApiResult)
        let productCoreDataService = MockProductCoreDataService(mockGetResult: .success(mockProductCoreData), mockSaveResult: .success(()))

        let receiveValueIsCalled = XCTestExpectation(description: "receiveValueIsCalled")
        makeSUT(mockProductMapper: mockProductMapper, mockMoyaNetworkFacade: moyaNetworkFacade, mockProductCoreDataService: productCoreDataService)
         
        sut.getProducts(name: "iPhone", isLatest: true)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    XCTFail()
                    
                case .finished:
                    break
                }
            }, receiveValue: { products in
                receiveValueIsCalled.fulfill()
                XCTAssertEqual(products, mockProducts)
            })
            .store(in: &cancellables)
        
        wait(for: [receiveValueIsCalled], timeout: 1.0)
    }
    
    ///
    /// Test Product datasource returns failure.
    ///
    /// Expect:
    ///     1. `NSError(domain: "123", code: 100)`
    ///
    /// Condition:
    ///     1. function parameters   -> name: `"iPhone"`, isLatest: `true`
    ///     2. MockProductMapper     -> `[`Product(name: `"iPhone14"`), Product(name: `"iPhone13 pro max"`)`]`
    ///     3. MockMoyaNetworkFacade -> `NSError(domain: "123", code: 100)`
    ///     4. MockProductCoreDataService   -> mockGetResult:  .success(`[`Product(`"iPhone14"`), Product(`"iPhone13 pro max""`)`]`)
    ///                                        mockSaveResult: .success
    ///
    func testGetProductsFailureWithName() {
        // sut
        let mockProducts = [Product(name: "iPhone14"), Product(name: "iPhone13 pro max")]
        let mockError = NSError(domain: "123", code: 100)
        let mockProductApiResult: Result<ProductApiModel, Error> = .failure(mockError)
        let mockProductCoreData = makeMockCoreDataModel(names: ["iPhone14", "iPhone13 pro max"])

        let mockProductMapper = MockProductMapper(mockProducts: mockProducts)
        let moyaNetworkFacade = MockMoyaNetworkFacade(mockProductApiResult: mockProductApiResult)
        let productCoreDataService = MockProductCoreDataService(mockGetResult: .success(mockProductCoreData), mockSaveResult: .success(()))

        let receiveErrorIsCalled = XCTestExpectation(description: "receiveErrorIsCalled")
        makeSUT(mockProductMapper: mockProductMapper, mockMoyaNetworkFacade: moyaNetworkFacade, mockProductCoreDataService: productCoreDataService)

        sut.getProducts(name: "iPhone", isLatest: true)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    receiveErrorIsCalled.fulfill()
                    XCTAssertEqual(error as NSError, mockError)

                case .finished:
                    break
                }
            }, receiveValue: { products in
                XCTFail()
            })
            .store(in: &cancellables)

        wait(for: [receiveErrorIsCalled], timeout: 1.0)
    }
    
    private func makeSUT(mockProductMapper: ProductModelMapperType, mockMoyaNetworkFacade: MoyaNetworkFacadeType, mockProductCoreDataService: ProductCoreDataServiceType) {
        sut = ProductRepository(productMapper: mockProductMapper, moyaNetworkFacade: mockMoyaNetworkFacade, productCoreDataService: mockProductCoreDataService)
    }

    private func makeMockCoreDataModel(names: [String]) -> [Persistence.Product] {
        var products: [Persistence.Product] = []
        
        for name in names {
            let product = Persistence.Product(context: CoreDataController.shared.container.viewContext)
            product.name = name
            
            products.append(product)
        }
        
        return products
    }
}

// MARK: mock object
class MockMoyaNetworkFacade: MoyaNetworkFacadeType {
    
    private let mockProductApiResult: Result<ProductApiModel, Error>
    
    init(mockProductApiResult: Result<ProductApiModel, Error>) {
        self.mockProductApiResult = mockProductApiResult
    }
    
    func fetch<T>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error> where T : SCSH_3C_iOS.MoyaApiInterfaceType {
        switch mockProductApiResult {
        case .success(let apiModel):
            return Just(apiModel as! T.OutputModel)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}

class MockProductMapper: ProductModelMapperType {
    private let mockProducts: [SCSH_3C_iOS.Product]
    
    init(mockProducts: [SCSH_3C_iOS.Product]) {
        self.mockProducts = mockProducts
    }
    
    func transform(apiModel: SCSH_3C_iOS.ProductApiModel) -> [SCSH_3C_iOS.Product] {
        mockProducts
    }
    
    func transform(coreDataProducts: [Persistence.Product]) -> [SCSH_3C_iOS.Product] {
        mockProducts
    }
}

class MockProductCoreDataService: ProductCoreDataServiceType {
    private let mockGetResult: Result<[Persistence.Product], Error>
    private let mockSaveResult: Result<Void, Error>

    init(mockGetResult: Result<[Persistence.Product], Error>, mockSaveResult: Result<Void, Error>) {
        self.mockGetResult = mockGetResult
        self.mockSaveResult = mockSaveResult
    }
    
    func get(name: String?) -> AnyPublisher<[Persistence.Product], Error> {
        switch mockGetResult {
        case .success(let products):
            return Just(products)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func save(names: [String]) -> AnyPublisher<Void, Error> {
        switch mockSaveResult {
        case .success:
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
