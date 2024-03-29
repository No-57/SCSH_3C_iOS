//
//  CoreDataController.swift
//  Persistence
//
//  Created by 辜敬閎 on 2023/5/16.
//

import CoreData

public class CoreDataController {
    public static let shared = CoreDataController()

    public let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        // in order to load core data more accuratly, correspond to `CoreData.xcdatamodeld`
        let modelURL = Bundle(for: Self.self).url(forResource: "CoreData", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        container = NSPersistentCloudKitContainer(name: "CoreData", managedObjectModel: managedObjectModel!)

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
