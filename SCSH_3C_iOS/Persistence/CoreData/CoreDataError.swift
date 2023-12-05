//
//  CoreDataError.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/12/2.
//

import Foundation

enum CoreDataError: Error {
    case invalidManagedObjectContext
    case invalidProperty
    case duplicatedData
    case noSuchData
}
