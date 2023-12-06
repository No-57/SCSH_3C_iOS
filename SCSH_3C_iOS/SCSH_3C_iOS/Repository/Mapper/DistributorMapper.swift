//
//  DistributorMapper.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/12/6.
//

import Foundation
import Persistence
import Networking
import CoreData

protocol DistributorMapperType {
    func transform(networkDistributors distributors: [Networking.Distributor], context: NSManagedObjectContext) -> [Persistence.Distributor]
    func transform(persistenceDistributors distributors: [Persistence.Distributor]) -> [Distributor]
    
    func transform(networkDistributorLikes likes: [Networking.DistributorLike], context: NSManagedObjectContext) -> [Persistence.Distributor_Like]
}

class DistributorMapper: DistributorMapperType {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func transform(networkDistributors distributors: [Networking.Distributor], context: NSManagedObjectContext) -> [Persistence.Distributor] {
        distributors.map { distributor in
            let persistenceDistributor = Persistence.Distributor(context: context)
            persistenceDistributor.id = Int64(distributor.id)
            persistenceDistributor.name = distributor.name
            persistenceDistributor.detail = distributor.description
            persistenceDistributor.brand_image = URL(string: distributor.brandImage)
            persistenceDistributor.products = transform(networkDistributorProducts: distributor.products)
            
            return persistenceDistributor
        }
    }
    
    func transform(persistenceDistributors distributors: [Persistence.Distributor]) -> [Distributor] {
        var result: [Distributor] = []
        
        for distributor in distributors {
            
            var products: [Distributor.Product] = []
            
            if let productsData = distributor.products {
                products = (try? self.decode(distributorProductsData: productsData)) ?? []
            }
            
            result.append(Distributor(id: String(distributor.id),
                                      name: distributor.name ?? "",
                                      description: distributor.detail ?? "",
                                      brandImage: distributor.brand_image,
                                      products: products))
            
        }
        
        return result
    }
    
    func transform(networkDistributorLikes likes: [Networking.DistributorLike], context: NSManagedObjectContext) -> [Distributor_Like] {
        likes.map { like in
            let persistenceLike = Persistence.Distributor_Like(context: context)
            persistenceLike.id = Int64(like.id)
            
            return persistenceLike
        }
    }
    
    private func transform(networkDistributorProducts: [Networking.Distributor.Product]) -> Data? {
        let distributorProducts = networkDistributorProducts.map {
            Distributor.Product(id: String($0.id), image: URL(string: $0.image))
        }
        
        return try? encode(distributorProducts: distributorProducts)
    }
    
    private func encode(distributorProducts: [Distributor.Product]) throws -> Data {
        do {
            return try encoder.encode(distributorProducts)
            
        } catch {
            print("❌❌❌ DistributorMapper encode fail")
            print(error.localizedDescription)
            throw error
        }
    }
    
    private func decode(distributorProductsData: Data) throws -> [Distributor.Product] {
        do {
            return try decoder.decode([Distributor.Product].self, from: distributorProductsData)
            
        } catch {
            print("❌❌❌ DistributorMapper decode fail")
            print(error.localizedDescription)
            throw error
        }
    }
}
