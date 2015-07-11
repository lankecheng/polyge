//
//  DataStack.swift
//  CoreStore
//
//  Copyright (c) 2014 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import CoreData
import GCDKit


internal let applicationSupportDirectory = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask).first!

internal let applicationName = (NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String) ?? "CoreData"

internal let defaultSQLiteStoreURL = applicationSupportDirectory.URLByAppendingPathComponent(applicationName, isDirectory: false).URLByAppendingPathExtension("sqlite")


// MARK: - DataStack

/**
The `DataStack` encapsulates the data model for the Core Data stack. Each `DataStack` can have multiple data stores, usually specified as a "Configuration" in the model editor. Behind the scenes, the DataStack manages its own `NSPersistentStoreCoordinator`, a root `NSManagedObjectContext` for disk saves, and a shared `NSManagedObjectContext` designed as a read-only model interface for `NSManagedObjects`.
*/
public final class DataStack {
    
    // MARK: Public
    
    /**
    Initializes a `DataStack` from an `NSManagedObjectModel`.
    
    - parameter modelName: the name of the (.xcdatamodeld) model file. If not specified, the application name will be used
    - parameter bundle: an optional bundle to load models from. If not specified, the main bundle will be used.
    - parameter migrationChain: the `MigrationChain` that indicates the heirarchy of the model's version names. If not specified, will default to a non-migrating data stack.
    */
    public required init(modelName: String = applicationName, bundle: NSBundle = NSBundle.mainBundle(), migrationChain: MigrationChain = nil) {
        
        CoreStore.assert(
            migrationChain.valid,
            "Invalid migration chain passed to the \(typeName(DataStack)). Check that the model versions' order is correct and that no repetitions or ambiguities exist."
        )
        
        let model = NSManagedObjectModel.fromBundle(
            bundle,
            modelName: modelName,
            modelVersion: migrationChain.leafVersions.first
        )
        
        self.coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        self.rootSavingContext = NSManagedObjectContext.rootSavingContextForCoordinator(self.coordinator)
        self.mainContext = NSManagedObjectContext.mainContextForRootContext(self.rootSavingContext)
        self.bundle = bundle
        self.model = model
        self.migrationChain = migrationChain
        
        self.rootSavingContext.parentStack = self
    }
    
    /**
    Adds an in-memory store to the stack.
    
    - parameter configuration: an optional configuration name from the model file. If not specified, defaults to nil.
    - returns: a `PersistentStoreResult` indicating success or failure.
    */
    public func addInMemoryStore(configuration configuration: String? = nil) -> PersistentStoreResult {
        
        let coordinator = self.coordinator;
        
        var store: NSPersistentStore?
        var storeError: NSError?
        coordinator.performBlockAndWait {
            
            do {
                
                store = try coordinator.addPersistentStoreWithType(
                    NSInMemoryStoreType,
                    configuration: configuration,
                    URL: nil,
                    options: nil
                )
            }
            catch {
                
                storeError = error as NSError
            }
        }
        
        if let store = store {
            
            self.updateMetadataForPersistentStore(store)
            return PersistentStoreResult(store)
        }
        
        if let error = storeError {
            
            CoreStore.handleError(
                error,
                "Failed to add in-memory \(typeName(NSPersistentStore))."
            )
            return PersistentStoreResult(error)
        }
        else {
            
            CoreStore.handleError(
                NSError(coreStoreErrorCode: .UnknownError),
                "Failed to add in-memory \(typeName(NSPersistentStore))."
            )
            return PersistentStoreResult(.UnknownError)
        }
    }
    
    /**
    Adds to the stack an SQLite store from the given SQLite file name.
    
    - parameter fileName: the local filename for the SQLite persistent store in the "Application Support" directory. A new SQLite file will be created if it does not exist. Note that if you have multiple configurations, you will need to specify a different `fileName` explicitly for each of them.
    - parameter configuration: an optional configuration name from the model file. If not specified, defaults to `nil`, the "Default" configuration. Note that if you have multiple configurations, you will need to specify a different `fileName` explicitly for each of them.
    - parameter automigrating: Set to true to configure Core Data auto-migration, or false to disable. If not specified, defaults to true.
    - parameter resetStoreOnMigrationFailure: Set to true to delete the store on migration failure; or set to false to throw exceptions on failure instead. Typically should only be set to true when debugging, or if the persistent store can be recreated easily. If not specified, defaults to false
    - returns: a `PersistentStoreResult` indicating success or failure.
    */
    public func addSQLiteStoreAndWait(fileName fileName: String, configuration: String? = nil, automigrating: Bool = true, resetStoreOnMigrationFailure: Bool = false) -> PersistentStoreResult {
        
        return self.addSQLiteStoreAndWait(
            fileURL: applicationSupportDirectory.URLByAppendingPathComponent(
                fileName,
                isDirectory: false
            ),
            configuration: configuration,
            automigrating: automigrating,
            resetStoreOnMigrationFailure: resetStoreOnMigrationFailure
        )
    }
    
    /**
    Adds to the stack an SQLite store from the given SQLite file URL.
    
    - parameter fileURL: the local file URL for the SQLite persistent store. A new SQLite file will be created if it does not exist. If not specified, defaults to a file URL pointing to a "<Application name>.sqlite" file in the "Application Support" directory. Note that if you have multiple configurations, you will need to specify a different `fileURL` explicitly for each of them.
    - parameter configuration: an optional configuration name from the model file. If not specified, defaults to `nil`, the "Default" configuration. Note that if you have multiple configurations, you will need to specify a different `fileURL` explicitly for each of them.
    - parameter automigrating: Set to true to configure Core Data auto-migration, or false to disable. If not specified, defaults to true.
    - parameter resetStoreOnMigrationFailure: Set to true to delete the store on migration failure; or set to false to throw exceptions on failure instead. Typically should only be set to true when debugging, or if the persistent store can be recreated easily. If not specified, defaults to false.
    - returns: a `PersistentStoreResult` indicating success or failure.
    */
    public func addSQLiteStoreAndWait(fileURL fileURL: NSURL = defaultSQLiteStoreURL, configuration: String? = nil, automigrating: Bool = true, resetStoreOnMigrationFailure: Bool = false) -> PersistentStoreResult {
        
        let coordinator = self.coordinator;
        if let store = coordinator.persistentStoreForURL(fileURL) {
            
            let isExistingStoreAutomigrating = (store.options?[NSMigratePersistentStoresAutomaticallyOption] as? Bool) == true
            
            if store.type == NSSQLiteStoreType
                && isExistingStoreAutomigrating == automigrating
                && store.configurationName == (configuration ?? Into.defaultConfigurationName) {
                    
                    return PersistentStoreResult(store)
            }
            
            CoreStore.handleError(
                NSError(coreStoreErrorCode: .DifferentPersistentStoreExistsAtURL),
                "Failed to add SQLite \(typeName(NSPersistentStore)) at \"\(fileURL)\" because a different \(typeName(NSPersistentStore)) at that URL already exists."
            )
            
            return PersistentStoreResult(.DifferentPersistentStoreExistsAtURL)
        }
        
        let fileManager = NSFileManager.defaultManager()
        do {
            
            try fileManager.createDirectoryAtURL(
                fileURL.URLByDeletingLastPathComponent!,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        catch _ { }
        
        var store: NSPersistentStore?
        var storeError: NSError?
        coordinator.performBlockAndWait {
            
            do {
                
                store = try coordinator.addPersistentStoreWithType(
                    NSSQLiteStoreType,
                    configuration: configuration,
                    URL: fileURL,
                    options: [
                        NSSQLitePragmasOption: ["journal_mode": "WAL"],
                        NSInferMappingModelAutomaticallyOption: true,
                        NSMigratePersistentStoresAutomaticallyOption: automigrating
                    ]
                )
            }
            catch {
                
                storeError = error as NSError
            }
        }
        
        if let store = store {
            
            self.updateMetadataForPersistentStore(store)
            return PersistentStoreResult(store)
        }
        
        if let error = storeError
            where (
                resetStoreOnMigrationFailure
                    && (error.code == NSPersistentStoreIncompatibleVersionHashError
                        || error.code == NSMigrationMissingSourceModelError
                        || error.code == NSMigrationError)
                    && error.domain == NSCocoaErrorDomain
            ) {
                
                do {
                    
                    try fileManager.removeItemAtURL(fileURL)
                }
                catch _ { }
                
                do {
                    
                    try fileManager.removeItemAtPath(fileURL.path!.stringByAppendingString("-shm"))
                }
                catch _ { }
                
                do {
                    
                    try fileManager.removeItemAtPath(fileURL.path!.stringByAppendingString("-wal"))
                }
                catch _ { }
                
                var store: NSPersistentStore?
                coordinator.performBlockAndWait {
                    
                    do {
                        
                        store = try coordinator.addPersistentStoreWithType(
                            NSSQLiteStoreType,
                            configuration: configuration,
                            URL: fileURL,
                            options: [
                                NSSQLitePragmasOption: ["journal_mode": "WAL"],
                                NSInferMappingModelAutomaticallyOption: true,
                                NSMigratePersistentStoresAutomaticallyOption: automigrating
                            ]
                        )
                    }
                    catch {
                        
                        storeError = error as NSError
                    }
                }
                
                if let store = store {
                    
                    self.updateMetadataForPersistentStore(store)
                    return PersistentStoreResult(store)
                }
        }
        
        CoreStore.handleError(
            storeError ?? NSError(coreStoreErrorCode: .UnknownError),
            "Failed to add SQLite \(typeName(NSPersistentStore)) at \"\(fileURL)\"."
        )
        
        return PersistentStoreResult(.UnknownError)
    }
    
    
    // MARK: Internal
    
    internal let coordinator: NSPersistentStoreCoordinator
    internal let rootSavingContext: NSManagedObjectContext
    internal let mainContext: NSManagedObjectContext
    internal let bundle: NSBundle
    internal let model: NSManagedObjectModel
    internal let migrationChain: MigrationChain
    internal let childTransactionQueue: GCDQueue = .createSerial("com.corestore.datastack.childtransactionqueue")
    internal let migrationQueue: NSOperationQueue = {
        
        let migrationQueue = NSOperationQueue()
        migrationQueue.maxConcurrentOperationCount = 1
        migrationQueue.name = "com.coreStore.migrationOperationQueue"
        migrationQueue.qualityOfService = .Utility
        migrationQueue.underlyingQueue = dispatch_queue_create("com.coreStore.migrationQueue", DISPATCH_QUEUE_SERIAL)
        return migrationQueue
    }()
    
    internal func entityNameForEntityClass(entityClass: AnyClass) -> String? {
        
        return self.model.entityNameForClass(entityClass)
    }
    
    internal func persistentStoresForEntityClass(entityClass: AnyClass) -> [NSPersistentStore]? {
        
        var returnValue: [NSPersistentStore]? = nil
        self.storeMetadataUpdateQueue.barrierSync {
            
            returnValue = self.entityConfigurationsMapping[NSStringFromClass(entityClass)]?.map {
                
                return self.configurationStoreMapping[$0]!
            } ?? []
        }
        return returnValue
    }
    
    internal func persistentStoreForEntityClass(entityClass: AnyClass, configuration: String?, inferStoreIfPossible: Bool) -> (store: NSPersistentStore?, isAmbiguous: Bool) {
        
        var returnValue: (store: NSPersistentStore?, isAmbiguous: Bool) = (store: nil, isAmbiguous: false)
        self.storeMetadataUpdateQueue.barrierSync {
            
            let configurationsForEntity = self.entityConfigurationsMapping[NSStringFromClass(entityClass)] ?? []
            if let configuration = configuration {
                
                if configurationsForEntity.contains(configuration) {
                    
                    returnValue = (store: self.configurationStoreMapping[configuration], isAmbiguous: false)
                    return
                }
                else if !inferStoreIfPossible {
                    
                    return
                }
            }
            
            switch configurationsForEntity.count {
                
            case 0:
                return
                
            case 1 where inferStoreIfPossible:
                returnValue = (store: self.configurationStoreMapping[configurationsForEntity.first!], isAmbiguous: false)
                
            default:
                returnValue = (store: nil, isAmbiguous: true)
            }
        }
        return returnValue
    }
    
    internal func updateMetadataForPersistentStore(persistentStore: NSPersistentStore) {
        
        self.storeMetadataUpdateQueue.barrierAsync {
            
            let configurationName = persistentStore.configurationName
            self.configurationStoreMapping[configurationName] = persistentStore
            for entityDescription in (self.coordinator.managedObjectModel.entitiesForConfiguration(configurationName) ?? []) {
                
                if self.entityConfigurationsMapping[entityDescription.managedObjectClassName] == nil {
                    
                    self.entityConfigurationsMapping[entityDescription.managedObjectClassName] = []
                }
                self.entityConfigurationsMapping[entityDescription.managedObjectClassName]?.insert(configurationName)
            }
        }
    }
    
    
    // MARK: Private
    
    private let storeMetadataUpdateQueue = GCDQueue.createConcurrent("com.coreStore.persistentStoreBarrierQueue")
    private var configurationStoreMapping = [String: NSPersistentStore]()
    private var entityConfigurationsMapping = [String: Set<String>]()
    
    deinit {
        
        for store in self.coordinator.persistentStores {
            
            do {
                
                try self.coordinator.removePersistentStore(store)
            }
            catch _ { }
        }
    }
}
