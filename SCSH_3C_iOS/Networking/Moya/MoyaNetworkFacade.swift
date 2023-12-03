//
//  MoyaNetworkFacade.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/7/31.
//

import Foundation
import Moya
import Combine

public protocol MoyaNetworkFacadeType {
    func fetch<T: MoyaApiInterfaceType>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error>
    
    // TODO: only available in `development` config.
    func stubFetch<T: MoyaApiInterfaceType>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error>
}

public extension MoyaNetworkFacadeType {
    func stubFetch<T: MoyaApiInterfaceType>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error> {
        Empty<T.OutputModel, Error>().eraseToAnyPublisher()
    }
}

public class MoyaNetworkFacade: MoyaNetworkFacadeType {
    
    private var activeService: Any?
    
    public init() {}
    
    public func fetch<T: MoyaApiInterfaceType>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error> {
        Future<T.OutputModel, Error> { [weak self] promise in
            guard let self = self else { return }
            
            self.fetch(apiInterface: apiInterface, success: { outputModel in
                promise(.success(outputModel))
            }, failure: { error in
                promise(.failure(error))
            })
        }
        .eraseToAnyPublisher()
    }
    
    private func fetch<T: MoyaApiInterfaceType>(apiInterface: T, success: @escaping (T.OutputModel) -> Void, failure: @escaping (Error) -> Void) {
        let provider = MoyaProvider<T>()
        let networkService = MoyaNetworkService(moyaProvider: provider, moyaApiInterface: apiInterface)
        activeService = networkService // ⚠️ retain it temporarily
        
        networkService.fetch(success: success, failure: failure)
    }
}

// TODO: only available in `development` config.
extension MoyaNetworkFacade {
    
    public func stubFetch<T: MoyaApiInterfaceType>(apiInterface: T) -> AnyPublisher<T.OutputModel, Error> {
        Future<T.OutputModel, Error> { [weak self] promise in
            guard let self = self else { return }
            
            let stubProvider = MoyaProvider<T>(endpointClosure: { target -> Endpoint in
                
                return Endpoint(url: URL(target: target).absoluteString,
                                sampleResponseClosure: { .networkResponse(200, self.getMockData(apiInterface: apiInterface)) },
                                method: target.method,
                                task: target.task,
                                httpHeaderFields: target.headers)
            }, stubClosure: MoyaProvider.immediatelyStub)
            
            let networkService = MoyaNetworkService(moyaProvider: stubProvider, moyaApiInterface: apiInterface)
            self.activeService = networkService // ⚠️ retain it temporarily
            
            networkService.fetch(success: { outputModel in
                promise(.success(outputModel))
            }, failure: { error in
                promise(.failure(error))
            })
        }
        .eraseToAnyPublisher()
    }
    
    private func getMockData<T>(apiInterface: T) -> Data {
        switch apiInterface {
        case is BoardApiInterface:
            return getMockBoardApiResponse()
            
        case is ThemeApiInterface:
            let apiInterface = apiInterface as! ThemeApiInterface
            
            switch apiInterface.path.split(separator: "/").last {
            case "home":
                return getMockHomeThemeApiResponse()
            case "explore":
                return getMockExploreThemeApiResponse()
            default:
                fatalError()
            }
            
        case is DistributorApiInterface:
            return getMockDistributorApiResponse()
            
        case is DistributorLikeApiInterface.Get:
            return getMockGetDistributorsLikeApiResponse()
            
        case is DistributorLikeApiInterface.Post,
             is DistributorLikeApiInterface.Delete:
            return getMockPostOrDeleteDistributorsLikeApiResponse()
        
        default:
            fatalError()
        }
    }

    private struct MockApiResponse<Data: Codable>: Codable {
        public let code: Int
        public let data: Data
    }
    
    private struct MockEmptyApiResponse: Codable {
        public let code: Int
    }
    
    // Delete it when API `/boards` is ready.
    private func getMockBoardApiResponse() -> Data {
        try! JSONEncoder().encode(
            MockApiResponse(code: 10010,
                            data: [Board(id: 1,
                                         code: "explore_carousel_board",
                                         imageUrl: "https://images.pexels.com/photos/15484171/pexels-photo-15484171/free-photo-of-a-black-and-white-photo-of-the-ocean.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                                         actionType: "web_link",
                                         action: "https://images.pexels.com/photos/15484171/pexels-photo-15484171/free-photo-of-a-black-and-white-photo-of-the-ocean.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                                   Board(id: 2,
                                         code: "explore_carousel_board",
                                         imageUrl: "https://images.pexels.com/photos/18395712/pexels-photo-18395712/free-photo-of-bmw-e30-parked-on-the-desert.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                                         actionType: nil,
                                         action: nil),
                                   Board(id: 3,
                                         code: "explore_carousel_board",
                                         imageUrl: "https://cdn.pixabay.com/photo/2023/10/18/15/43/compass-8324516_1280.jpg",
                                         actionType: "web_link",
                                         action: "https://cdn.pixabay.com/photo/2023/10/18/15/43/compass-8324516_1280.jpg"),
                                   Board(id: 4,
                                         code: "explore_carousel_board",
                                         imageUrl: "https://cdn.pixabay.com/photo/2023/10/03/07/46/hamburg-8290719_1280.jpg",
                                         actionType: "web_link",
                                         action: "https://cdn.pixabay.com/photo/2023/10/03/07/46/hamburg-8290719_1280.jpg"),
                                   Board(id: 5,
                                         code: "explore_carousel_board",
                                         imageUrl: "https://cdn.pixabay.com/photo/2023/08/29/19/42/goose-8222013_1280.jpg",
                                         actionType: nil,
                                         action: nil),
                            ])
        )
    }
    
    // Delete it when API `/themes/{type}` is ready.
    private func getMockExploreThemeApiResponse() -> Data {
        try! JSONEncoder().encode(
            MockApiResponse(code: 10010,
                            data: [
                                Theme(id: 1, type: "explore", code: "board"),
                                Theme(id: 2, type: "explore", code: "recent"),
                                Theme(id: 3, type: "explore", code: "distributor"),
                                Theme(id: 4, type: "explore", code: "popular"),
                                Theme(id: 5, type: "explore", code: "explore"),
                            ])
        )
    }
    
    private func getMockHomeThemeApiResponse() -> Data {
        try! JSONEncoder().encode(
            MockApiResponse(code: 10010,
                            data: [
                                Theme(id: 10, type: "home", code: "explore"),
                                Theme(id: 11, type: "home", code: "subject"),
                                Theme(id: 12, type: "home", code: "special"),
                                Theme(id: 13, type: "home", code: "product_3C"),
                                Theme(id: 14, type: "home", code: "game_point"),
                                Theme(id: 15, type: "home", code: "distributor_PChome"),
                            ])
        )
    }
    
    // Delete it when API `/distributors?limit={limit}` is ready.
    private func getMockDistributorApiResponse() -> Data {
        try! JSONEncoder().encode(
            MockApiResponse(code: 10010,
                            data: [
                                Distributor(id: 1,
                                            name: "PChome",
                                            description: "台灣電商龍頭 ^^ <3",
                                            brandImage:  "https://images.pexels.com/photos/1287145/pexels-photo-1287145.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                                            products: [
                                                Distributor.Product(id: 1,
                                                                    image: "https://images.pexels.com/photos/12762122/pexels-photo-12762122.jpeg"),
                                                Distributor.Product(id: 2,
                                                                    image:  "https://images.pexels.com/photos/12784538/pexels-photo-12784538.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                                                Distributor.Product(id: 3,
                                                                    image: "https://images.pexels.com/photos/12792288/pexels-photo-12792288.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                                            ]),
                                Distributor(id: 2,
                                            name: "蝦皮購物",
                                            description: "財務危機ing RRR",
                                            brandImage:  "https://images.pexels.com/photos/2138922/pexels-photo-2138922.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                                            products: [
                                                Distributor.Product(id: 1,
                                                                    image: "https://images.pexels.com/photos/15324791/pexels-photo-15324791/free-photo-of-scenic-view-of-a-dirt-road-in-a-forest.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                                                Distributor.Product(id: 2,
                                                                    image:  "https://images.pexels.com/photos/802127/pexels-photo-802127.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                                                Distributor.Product(id: 3,
                                                                    image: "https://images.pexels.com/photos/15478177/pexels-photo-15478177/free-photo-of-trees-in-forest-in-fog.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                                            ]),
                                Distributor(id: 3,
                                            name: "momo購物",
                                            description: "要辦卡才會比較便宜",
                                            brandImage:  "https://images.pexels.com/photos/220201/pexels-photo-220201.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                                            products: [
                                                Distributor.Product(id: 1,
                                                                    image: "https://images.pexels.com/photos/5641973/pexels-photo-5641973.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                                                Distributor.Product(id: 2,
                                                                    image:  "https://images.pexels.com/photos/2078126/pexels-photo-2078126.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                                                Distributor.Product(id: 3,
                                                                    image: "https://images.pexels.com/photos/71116/hurricane-earth-satellite-tracking-71116.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                                            ]),
                            ])
        )
    }
    
    // Delete it when API GET `/distributors/{distributor_id}/like` is ready.
    private func getMockGetDistributorsLikeApiResponse() -> Data {
        try! JSONEncoder().encode(
            MockApiResponse(code: 10010,
                            data: [
                                DistributorLike(id: 1),
                                DistributorLike(id: 3),
                            ])
        )
    }
    
    // Delete it when API POST || DELETE `/distributors/{distributor_id}/like` is ready.
    private func getMockPostOrDeleteDistributorsLikeApiResponse() -> Data {
        try! JSONEncoder().encode(
            MockEmptyApiResponse(code: 10010)
        )
    }
}
