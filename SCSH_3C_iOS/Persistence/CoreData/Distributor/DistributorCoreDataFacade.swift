//
//  DistributorCoreDataFacade.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/4.
//

import Combine

public protocol DistributorCoreDataFacadeType {
    func getById(id: Int64) -> AnyPublisher<Distributor, Error>
    
    func get() -> AnyPublisher<[Distributor], Error>
    
    func save(distributors: [Distributor]) -> AnyPublisher<Void, Error>
    
    func save(likes: [Distributor_Like]) -> AnyPublisher<Void, Error>
    
    func save(likeId: Int64) -> AnyPublisher<Void, Error>
    
    func delete(likeId: Int64) -> AnyPublisher<Void, Error>
}

public class DistributorCoreDataFacade: DistributorCoreDataFacadeType {
    
    private let distributorCoreDataService: DistributorCoreDataServiceType = DistributorCoreDataService(distributorCoreDataDao: DistributorCoreDataDao(),
                                                                                                        distributorLikeCoreDataDao: DistributorLikeCoreDataDao())

    public init() {}
    
    public func getById(id: Int64) -> AnyPublisher<Distributor, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.distributorCoreDataService.getById(id: id))
        }
        .eraseToAnyPublisher()
    }
    
    public func get() -> AnyPublisher<[Distributor], Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.distributorCoreDataService.get())
        }
        .eraseToAnyPublisher()
    }
    
    public func save(distributors: [Distributor]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.distributorCoreDataService.save(distributors: distributors))
        }
        .eraseToAnyPublisher()
    }
    
    public func save(likes: [Distributor_Like]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.distributorCoreDataService.save(likes: likes))
        }
        .eraseToAnyPublisher()
    }
    
    public func save(likeId: Int64) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.distributorCoreDataService.save(likeId: likeId))
        }
        .eraseToAnyPublisher()
    }
    
    public func delete(likeId: Int64) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            promise(self.distributorCoreDataService.delete(likeId: likeId))
        }
        .eraseToAnyPublisher()
    }
}
