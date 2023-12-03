//
//  DistributorRepository.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/11/13.
//

import Foundation
import Combine

protocol DistributorRepositoryType {
    func getDistributors(isLatest: Bool) -> AnyPublisher<[Distributor], Error>
}

class DistributorRepository: DistributorRepositoryType {
    
    // TODO: API design is required.

    ///
    /// ```
    /// GET https://{domainhost}/distributors
    /// ?limit={limit}`
    /// ```
    ///
    /// Response: {
    /// ```
    ///     "data": [
    ///         { "id": ...,
    ///           "name": ...,
    ///           "description": ...,
    ///           "brandImage": ...,
    ///           "products": [
    ///               { "id":...,
    ///                 "image":..., }
    ///            ]},
    ///     ]
    /// ```
    /// }
    ///
    func getDistributors(isLatest: Bool) -> AnyPublisher<[Distributor], Error> {
        Future { promise in 
            promise(.success([
                Distributor(id: "網家",
                            name: "PChome",
                            description: "台灣電商龍頭 ^^ <3",
                            brandImage: URL(string: "https://images.pexels.com/photos/1287145/pexels-photo-1287145.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!,
                            products: [
                                Distributor.Product(id: "山1",
                                                    image: URL(string: "https://images.pexels.com/photos/12762122/pexels-photo-12762122.jpeg")!),
                                Distributor.Product(id: "山2",
                                                    image: URL(string: "https://images.pexels.com/photos/12784538/pexels-photo-12784538.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                                Distributor.Product(id: "山3",
                                                    image: URL(string: "https://images.pexels.com/photos/12792288/pexels-photo-12792288.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                            ]),
                
                Distributor(id: "蝦皮",
                            name: "蝦皮購物",
                            description: "財務危機ing RRR",
                            brandImage: URL(string: "https://images.pexels.com/photos/2138922/pexels-photo-2138922.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!,
                            products: [
                                Distributor.Product(id: "樹1",
                                                    image: URL(string: "https://images.pexels.com/photos/15324791/pexels-photo-15324791/free-photo-of-scenic-view-of-a-dirt-road-in-a-forest.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                                Distributor.Product(id: "樹2",
                                                    image: URL(string: "https://images.pexels.com/photos/802127/pexels-photo-802127.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                                Distributor.Product(id: "樹3",
                                                    image: URL(string: "https://images.pexels.com/photos/15478177/pexels-photo-15478177/free-photo-of-trees-in-forest-in-fog.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                            ]),

                Distributor(id: "momo",
                            name: "momo購物",
                            description: "要辦卡才會比較便宜",
                            brandImage: URL(string: "https://images.pexels.com/photos/220201/pexels-photo-220201.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!,
                            products: [
                                Distributor.Product(id: "太空1",
                                                    image: URL(string: "https://images.pexels.com/photos/5641973/pexels-photo-5641973.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                                Distributor.Product(id: "太空2",
                                                    image: URL(string: "https://images.pexels.com/photos/2078126/pexels-photo-2078126.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                                Distributor.Product(id: "太空3",
                                                    image: URL(string: "https://images.pexels.com/photos/71116/hurricane-earth-satellite-tracking-71116.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2")!),
                            ]),
            ]))
        }
        .eraseToAnyPublisher()
    }
}
