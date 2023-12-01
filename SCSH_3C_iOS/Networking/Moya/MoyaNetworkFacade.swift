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
        default:
            fatalError()
        }
    }

    private struct MockApiResponse<Data: Codable>: Codable {
        public let code: Int
        public let data: Data
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
}
