//
//  DistributorRepository.swift
//  SCSH_3C_iOS
//
//  Created by 辜敬閎 on 2023/11/13.
//

import Foundation
import Combine
import CoreData
import Persistence
import Networking

protocol DistributorRepositoryType {
    func getDistributors(isLatest: Bool) -> AnyPublisher<[Distributor], Error>
    func addLike(id: Int) -> AnyPublisher<Void, Error>
    func deleteLike(id: Int) -> AnyPublisher<Void, Error>
}

class DistributorRepository: DistributorRepositoryType {
    
    private let mapper: DistributorMapperType
    private let moyaNetworkFacade: MoyaNetworkFacadeType
    private let distributorCoreDataFacade: DistributorCoreDataFacadeType
    
    private let coreDataBackgroundContext = Persistence.CoreDataController.shared.container.newBackgroundContext()
    
    init(mapper: DistributorMapperType, moyaNetworkFacade: MoyaNetworkFacadeType, distributorCoreDataFacade: DistributorCoreDataFacadeType) {
        self.mapper = mapper
        self.moyaNetworkFacade = moyaNetworkFacade
        self.distributorCoreDataFacade = distributorCoreDataFacade
    }
    
    func getDistributors(isLatest: Bool) -> AnyPublisher<[Distributor], Error> {
        if isLatest {
            return fetchDistributors()
                .combineLatest(fetchDistributorsLike())
                .flatMap { [weak self] _ -> AnyPublisher<[Distributor], Error> in
                    guard let self = self else {
                        return Empty<[Distributor], Error>().eraseToAnyPublisher()
                    }
                    
                    return self.getDistributors()
                }
                .eraseToAnyPublisher()
        }
        
        return getDistributors()
    }
    
    func addLike(id: Int) -> AnyPublisher<Void, Error> {
        // TODO: Use `fetch` when API POST `/distributors/{distributor_id}/like` is ready
        moyaNetworkFacade.stubFetch(apiInterface: DistributorLikeApiInterface.Post(id: id))
            .flatMap { [weak self] _ -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                
                return self.distributorCoreDataFacade.save(likeId: Int64(id))
            }
            .eraseToAnyPublisher()
    }
    
    func deleteLike(id: Int) -> AnyPublisher<Void, Error> {
        // TODO: Use `fetch` when DELETE API `/distributors/{distributor_id}/like` is ready
        moyaNetworkFacade.stubFetch(apiInterface: DistributorLikeApiInterface.Delete(id: id))
            .flatMap { [weak self] _ -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }
                
                return self.distributorCoreDataFacade.delete(likeId: Int64(id))
            }
            .eraseToAnyPublisher()
    }
    
    private func fetchDistributors() -> AnyPublisher<Void, Error> {
        // TODO: Use `fetch` when API `/distributors?limit={limit}` is ready
        moyaNetworkFacade.stubFetch(apiInterface: DistributorApiInterface())
            .map(\.data)
            .map { [weak self] distributors -> [Persistence.Distributor] in
                guard let self = self else { return [] }
                
                return self.mapper.transform(networkDistributors: distributors, context: self.coreDataBackgroundContext)
            }
            .flatMap { [weak self] distributors -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }

                return self.distributorCoreDataFacade.save(distributors: distributors)
            }
            .eraseToAnyPublisher()
            
    }
    
    private func fetchDistributorsLike() -> AnyPublisher<Void, Error> {
        // TODO: Use `fetch` when API `/distributors/like` is ready
        moyaNetworkFacade.stubFetch(apiInterface: DistributorLikeApiInterface.Get())
            .map(\.data)
            .map { [weak self] likes -> [Persistence.Distributor_Like] in
                guard let self = self else { return [] }
                
                
                return self.mapper.transform(networkDistributorLikes: likes, context: self.coreDataBackgroundContext)
            }
            .flatMap { [weak self] likes -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Empty<Void, Error>().eraseToAnyPublisher()
                }

                return self.distributorCoreDataFacade.save(likes: likes)
            }
            .eraseToAnyPublisher()
    }
    
    private func getDistributors() -> AnyPublisher<[Distributor], Error> {
        distributorCoreDataFacade.get()
            .map { [weak self] distributors -> [Distributor] in
                guard let self = self else { return [] }
                
                return self.mapper.transform(persistenceDistributors: distributors)
            }
            .eraseToAnyPublisher()
    }
}
