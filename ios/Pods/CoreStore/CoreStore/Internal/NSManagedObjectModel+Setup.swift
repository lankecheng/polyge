//
//  NSManagedObjectModel+Setup.swift
//  CoreStore
//
//  Copyright (c) 2015 John Rommel Estropia
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


// MARK: - NSManagedObjectModel

internal extension NSManagedObjectModel {
    
    // MARK: Internal
    
    private var modelFileURL: NSURL? {
        
        get {
            
            return self.modelVersionFileURL?.URLByDeletingLastPathComponent
        }
    }
    
    private(set) var currentModelVersion: String? {
        
        get {
            
            let value: NSString? = getAssociatedObjectForKey(
                &PropertyKeys.currentModelVersion,
                inObject: self
            )
            return value as? String
        }
        set {
            
            setAssociatedCopiedObject(
                newValue == nil ? nil : (newValue! as NSString),
                forKey: &PropertyKeys.currentModelVersion,
                inObject: self
            )
        }
    }
    
    private(set) var modelVersions: Set<String>? {
        
        get {
            
            let value: NSSet? = getAssociatedObjectForKey(
                &PropertyKeys.modelVersions,
                inObject: self
            )
            return value as? Set<String>
        }
        set {
            
            setAssociatedCopiedObject(
                newValue == nil ? nil : (newValue! as NSSet),
                forKey: &PropertyKeys.modelVersions,
                inObject: self
            )
        }
    }
    
    func entityNameForClass(entityClass: AnyClass) -> String {
        
        return self.entityNameMapping[NSStringFromClass(entityClass)]!
    }
    
    func mergedModels() -> [NSManagedObjectModel] {
        
        return self.modelVersions?.map { self[$0] }.flatMap { $0 == nil ? [] : [$0!] } ?? [self]
    }
    
    subscript(modelVersion: String) -> NSManagedObjectModel? {
        
        if modelVersion == self.currentModelVersion {
            
            return self
        }
        
        guard let modelFileURL = self.modelFileURL,
            let modelVersions = self.modelVersions
            where modelVersions.contains(modelVersion) else {
                
                return nil
        }
        
        let versionModelFileURL = modelFileURL.URLByAppendingPathComponent("\(modelVersion).mom", isDirectory: false)
        guard let model = NSManagedObjectModel(contentsOfURL: versionModelFileURL) else {
            
            return nil
        }
        
        model.currentModelVersion = modelVersion
        model.modelVersionFileURL = versionModelFileURL
        model.modelVersions = modelVersions
        return model
    }
    
    class func fromBundle(bundle: NSBundle, modelName: String, modelVersion: String? = nil) -> NSManagedObjectModel {
        
        guard let modelFilePath = bundle.pathForResource(modelName, ofType: "momd") else {
            
            CoreStore.fatalError("Could not find \"\(modelName).momd\" from the bundle. \(bundle)")
        }
        
        let modelFileURL = NSURL(fileURLWithPath: modelFilePath)
        let versionInfoPlistURL = modelFileURL.URLByAppendingPathComponent("VersionInfo.plist", isDirectory: false)
        
        guard let versionInfo = NSDictionary(contentsOfURL: versionInfoPlistURL),
            let versionHashes = versionInfo["NSManagedObjectModel_VersionHashes"] as? [String: AnyObject] else {
                
                CoreStore.fatalError("Could not load \(typeName(NSManagedObjectModel)) metadata from path \"\(versionInfoPlistURL)\"."
                )
        }
        
        let modelVersions = Set(versionHashes.keys)
        let currentModelVersion: String
        
        if let modelVersion = modelVersion {
            
            precondition(modelVersions.contains(modelVersion))
            currentModelVersion = modelVersion
        }
        else {
            
            currentModelVersion = versionInfo["NSManagedObjectModel_CurrentVersionName"] as? String ?? modelVersions.first!
        }
        
        var modelVersionFileURL: NSURL?
        for modelVersion in modelVersions {
            
            let fileURL = modelFileURL.URLByAppendingPathComponent("\(modelVersion).mom", isDirectory: false)
            
            if modelVersion == currentModelVersion {
                
                modelVersionFileURL = fileURL
                continue
            }
            
            CoreStore.assert(
                NSManagedObjectModel(contentsOfURL: fileURL) != nil,
                "Could not find the \"\(modelVersion).mom\" version file for the model at URL \"\(modelFileURL)\"."
            )
        }
        
        if let modelVersionFileURL = modelVersionFileURL,
            let rootModel = NSManagedObjectModel(contentsOfURL: modelVersionFileURL) {
                
                rootModel.modelVersionFileURL = modelVersionFileURL
                rootModel.modelVersions = modelVersions
                rootModel.currentModelVersion = currentModelVersion
                return rootModel
        }
        
        CoreStore.fatalError("Could not create an \(typeName(NSManagedObjectModel)) from the model at URL \"\(modelFileURL)\".")
    }
    
    
    // MARK: Private
    
    private var modelVersionFileURL: NSURL? {
        
        get {
            
            let value: NSURL? = getAssociatedObjectForKey(
                &PropertyKeys.modelVersionFileURL,
                inObject: self
            )
            return value
        }
        set {
            
            setAssociatedCopiedObject(
                newValue,
                forKey: &PropertyKeys.modelVersionFileURL,
                inObject: self
            )
        }
    }
    
    private var entityNameMapping: [String: String] {
        
        get {
            
            if let mapping: NSDictionary = getAssociatedObjectForKey(&PropertyKeys.entityNameMapping, inObject: self) {
                
                return mapping as! [String: String]
            }
            
            let mapping = self.entities.reduce([String: String]()) {
                (var mapping, entityDescription) -> [String: String] in
                
                if let entityName = entityDescription.name {
                    
                    let className = entityDescription.managedObjectClassName
                    mapping[className] = entityName
                }
                return mapping
            }
            setAssociatedCopiedObject(
                mapping as NSDictionary,
                forKey: &PropertyKeys.entityNameMapping,
                inObject: self
            )
            return mapping
        }
    }
    
    private struct PropertyKeys {
        
        static var entityNameMapping: Void?
        
        static var modelVersionFileURL: Void?
        static var modelVersions: Void?
        static var currentModelVersion: Void?
    }
}