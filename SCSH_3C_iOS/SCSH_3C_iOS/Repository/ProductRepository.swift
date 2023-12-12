//
//  ProductRepository.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/11.
//

import Foundation
import Combine

protocol ProductRepositoryType {
    func getProducts(isLatest: Bool, page: Int) -> AnyPublisher<[Product], Error>
}

class ProductRepository: ProductRepositoryType {
    
    // TODO: implement Product in data layer.
    func getProducts(isLatest: Bool, page: Int) -> AnyPublisher<[Product], Error> {
        Future<[Product], Error> { promise in
            promise(.success([
                
                Product(id: 100,
                        name: "DELICATE PRESENT!",
                        image: URL(string: "https://images.pexels.com/photos/1693650/pexels-photo-1693650.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                        distributor:
                            Product.Distributor(id: 1,
                                                name: "蝦皮購物"),
                        
                        specialPrice: "388",
                        tagPrice: "3,888",
                        isLiked: false),
                
                Product(id: 101,
                        name: "聖誕節浪漫送禮",
                        image: URL(string: "https://images.pexels.com/photos/802505/pexels-photo-802505.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                        distributor:
                            Product.Distributor(id: 2,
                                                name: "PChome"),
                        
                        specialPrice: "1,299",
                        tagPrice: "1,999",
                        isLiked: true),
                
                Product(id: 102,
                        name: "Snow & Pinecone ❤️",
                        image: URL(string: "https://images.pexels.com/photos/5802147/pexels-photo-5802147.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                        distributor:
                            Product.Distributor(id: 3,
                                                name: "momo購物"),
                        
                        specialPrice: "799",
                        tagPrice: "1,000",
                        isLiked: true),
                
                Product(id: 103,
                        name: "奢華精緻系列 - 嚴選金箔香氛大禮盒",
                        image: URL(string: "https://images.pexels.com/photos/257855/pexels-photo-257855.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                        distributor:
                            Product.Distributor(id: 2,
                                                name: "PChome"),
                        
                        specialPrice: "6,666",
                        tagPrice: "10,000",
                        isLiked: false),
                
                Product(id: 104,
                        name: "低調奢華平面組合包 \n(設計師最愛)",
                        image: URL(string: "https://images.pexels.com/photos/1661903/pexels-photo-1661903.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                        distributor:
                            Product.Distributor(id: 2,
                                                name: "PChome"),
                        
                        specialPrice: "1,200",
                        tagPrice: "1,599",
                        isLiked: false),
                
                Product(id: 105,
                        name: "This is a bear carring a lot of gifts. (Bear is not selling)",
                        image: URL(string: "https://images.pexels.com/photos/264917/pexels-photo-264917.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"),
                        distributor:
                            Product.Distributor(id: 3,
                                                name: "momo購物"),
                        
                        specialPrice: "99",
                        tagPrice: "299",
                        isLiked: true),
                
            ]))
        }
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
