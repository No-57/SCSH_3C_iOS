//
//  DistributorCoreDataService.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/4.
//

import Foundation

protocol DistributorCoreDataServiceType {
    func getById(id: Int64) -> Result<Distributor, Error>
    
    func get() -> Result<[Distributor], Error>
    
    func save(distributors: [Distributor]) -> Result<Void, Error>
    
    func save(likes: [Distributor_Like]) -> Result<Void, Error>
    
    func save(likeId: Int64) -> Result<Void, Error>
    
    func delete(likeId: Int64) -> Result<Void, Error>
}

class DistributorCoreDataService: DistributorCoreDataServiceType {
    
    private let distributorCoreDataDao: DistributorCoreDataDaoType
    private let distributorLikeCoreDataDao: DistributorLikeCoreDataDaoType
    
    init(distributorCoreDataDao: DistributorCoreDataDaoType, distributorLikeCoreDataDao: DistributorLikeCoreDataDaoType) {
        self.distributorCoreDataDao = distributorCoreDataDao
        self.distributorLikeCoreDataDao = distributorLikeCoreDataDao
    }
    
    func getById(id: Int64) -> Result<Distributor, Error> {
        
        do {
            let distributors = try distributorCoreDataDao.get(id: id)
            let likes = try distributorLikeCoreDataDao.get(id: id)
            
            let result = mapLikesToDistributors(distributors: distributors, likes: likes)
            try validate(distributors: result)
            
            return .success(result[0])
            
        } catch {
            print("❌❌❌ DistributorCoreDataService getById fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    func get() -> Result<[Distributor], Error> {
        
        do {
            let distributors = try distributorCoreDataDao.get(id: nil)
            let likes = try distributorLikeCoreDataDao.get(id: nil)
            
            let result = mapLikesToDistributors(distributors: distributors, likes: likes)
            try validate(distributors: result)
            
            return .success(result)
            
        } catch {
            print("❌❌❌ DistributorCoreDataService get fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    func save(distributors: [Distributor]) -> Result<Void, Error> {
        
        do {
            try distributorCoreDataDao.truncate()
            try distributorCoreDataDao.insert(distributors: distributors)
            
            return .success(())
            
        } catch {
            print("❌❌❌ DistributorCoreDataService save(distributors:) fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    func save(likes: [Distributor_Like]) -> Result<Void, Error> {
        do {
            try distributorLikeCoreDataDao.truncate()
            try distributorLikeCoreDataDao.insert(likes: likes)
            
            return .success(())
            
        } catch {
            print("❌❌❌ DistributorCoreDataService save(likes:) fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    func save(likeId id: Int64) -> Result<Void, Error> {

        do {
            let result = try distributorLikeCoreDataDao.get(id: id)
            
            if !result.isEmpty {
                try distributorLikeCoreDataDao.delete(id: id)
            }
            
            try distributorLikeCoreDataDao.insert(id: id)
            
            return .success(())
            
        } catch {
            print("❌❌❌ DistributorCoreDataService save(likeId:) fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    func delete(likeId id: Int64) -> Result<Void, Error> {

        do {
            let result = try distributorLikeCoreDataDao.get(id: id)
            
            if !result.isEmpty {
                try distributorLikeCoreDataDao.delete(id: id)
            }
            
            return .success(())
            
        } catch {
            print("❌❌❌ DistributorCoreDataService delete fail !")
            print(error.localizedDescription)
            
            return .failure(error)
        }
    }
    
    private func validate(distributors: [Distributor]) throws {
        
        guard !distributors.isEmpty else {
            print("❌❌❌ DistributorCoreDataService validate fail, noSuchData!")
            
            throw CoreDataError.noSuchData
        }

        guard Set(distributors.map(\.id)).count == distributors.count else {
            print("❌❌❌ DistributorCoreDataService validate fail, duplicatedData!")
            
            throw CoreDataError.duplicatedData
        }
    }
    
    private func mapLikesToDistributors(distributors: [Distributor], likes: [Distributor_Like]) -> [Distributor] {
        distributors.map { distributor in
            guard let context = distributor.managedObjectContext,
                  let index = likes.map(\.id).firstIndex(of: distributor.id) else {
                return distributor
            }

            let like = Distributor_Like(context: context)
            like.id = likes[index].id
            
            distributor.distributor_like = like

            return distributor
        }
    }
}
