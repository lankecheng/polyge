//
//  DataStack+Querying.swift
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
import GCDKit


// MARK: - DataStack

public extension DataStack {
    
    // MARK: Public
    
    /**
    Fetches the first `NSManagedObject` instance that satisfies the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: the first `NSManagedObject` instance that satisfies the specified `FetchClause`s
    */
    public func fetchOne<T: NSManagedObject>(from: From<T>, _ fetchClauses: FetchClause...) -> T? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchOne(from, fetchClauses)
    }
    
    /**
    Fetches the first `NSManagedObject` instance that satisfies the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: the first `NSManagedObject` instance that satisfies the specified `FetchClause`s
    */
    public func fetchOne<T: NSManagedObject>(from: From<T>, _ fetchClauses: [FetchClause]) -> T? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchOne(from, fetchClauses)
    }
    
    /**
    Fetches all `NSManagedObject` instances that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: all `NSManagedObject` instances that satisfy the specified `FetchClause`s
    */
    public func fetchAll<T: NSManagedObject>(from: From<T>, _ fetchClauses: FetchClause...) -> [T]? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchAll(from, fetchClauses)
    }
    
    /**
    Fetches all `NSManagedObject` instances that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: all `NSManagedObject` instances that satisfy the specified `FetchClause`s
    */
    public func fetchAll<T: NSManagedObject>(from: From<T>, _ fetchClauses: [FetchClause]) -> [T]? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchAll(from, fetchClauses)
    }
    
    /**
    Fetches the number of `NSManagedObject`s that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: the number `NSManagedObject`s that satisfy the specified `FetchClause`s
    */
    public func fetchCount<T: NSManagedObject>(from: From<T>, _ fetchClauses: FetchClause...) -> Int? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchCount(from, fetchClauses)
    }
    
    /**
    Fetches the number of `NSManagedObject`s that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: the number `NSManagedObject`s that satisfy the specified `FetchClause`s
    */
    public func fetchCount<T: NSManagedObject>(from: From<T>, _ fetchClauses: [FetchClause]) -> Int? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchCount(from, fetchClauses)
    }
    
    /**
    Fetches the `NSManagedObjectID` for the first `NSManagedObject` that satisfies the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: the `NSManagedObjectID` for the first `NSManagedObject` that satisfies the specified `FetchClause`s
    */
    public func fetchObjectID<T: NSManagedObject>(from: From<T>, _ fetchClauses: FetchClause...) -> NSManagedObjectID? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchObjectID(from, fetchClauses)
    }
    
    /**
    Fetches the `NSManagedObjectID` for the first `NSManagedObject` that satisfies the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: the `NSManagedObjectID` for the first `NSManagedObject` that satisfies the specified `FetchClause`s
    */
    public func fetchObjectID<T: NSManagedObject>(from: From<T>, _ fetchClauses: [FetchClause]) -> NSManagedObjectID? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchObjectID(from, fetchClauses)
    }
    
    /**
    Fetches the `NSManagedObjectID` for all `NSManagedObject`s that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: the `NSManagedObjectID` for all `NSManagedObject`s that satisfy the specified `FetchClause`s
    */
    public func fetchObjectIDs<T: NSManagedObject>(from: From<T>, _ fetchClauses: FetchClause...) -> [NSManagedObjectID]? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchObjectIDs(from, fetchClauses)
    }
    
    /**
    Fetches the `NSManagedObjectID` for all `NSManagedObject`s that satisfy the specified `FetchClause`s. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter fetchClauses: a series of `FetchClause` instances for the fetch request. Accepts `Where`, `OrderBy`, and `Tweak` clauses.
    - returns: the `NSManagedObjectID` for all `NSManagedObject`s that satisfy the specified `FetchClause`s
    */
    public func fetchObjectIDs<T: NSManagedObject>(from: From<T>, _ fetchClauses: [FetchClause]) -> [NSManagedObjectID]? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to fetch from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.fetchObjectIDs(from, fetchClauses)
    }
    
    /**
    Queries aggregate values as specified by the `QueryClause`s. Requires at least a `Select` clause, and optional `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
    
    A "query" differs from a "fetch" in that it only retrieves values already stored in the persistent store. As such, values from unsaved transactions or contexts will not be incorporated in the query result.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter selectClause: a `Select<U>` clause indicating the properties to fetch, and with the generic type indicating the return type.
    - parameter queryClauses: a series of `QueryClause` instances for the query request. Accepts `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
    - returns: the result of the the query. The type of the return value is specified by the generic type of the `Select<U>` parameter.
    */
    public func queryValue<T: NSManagedObject, U: SelectValueResultType>(from: From<T>, _ selectClause: Select<U>, _ queryClauses: QueryClause...) -> U? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to query from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.queryValue(from, selectClause, queryClauses)
    }
    
    /**
    Queries aggregate values as specified by the `QueryClause`s. Requires at least a `Select` clause, and optional `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
    
    A "query" differs from a "fetch" in that it only retrieves values already stored in the persistent store. As such, values from unsaved transactions or contexts will not be incorporated in the query result.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter selectClause: a `Select<U>` clause indicating the properties to fetch, and with the generic type indicating the return type.
    - parameter queryClauses: a series of `QueryClause` instances for the query request. Accepts `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
    - returns: the result of the the query. The type of the return value is specified by the generic type of the `Select<U>` parameter.
    */
    public func queryValue<T: NSManagedObject, U: SelectValueResultType>(from: From<T>, _ selectClause: Select<U>, _ queryClauses: [QueryClause]) -> U? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to query from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.queryValue(from, selectClause, queryClauses)
    }
    
    /**
    Queries a dictionary of attribute values as specified by the `QueryClause`s. Requires at least a `Select` clause, and optional `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
    
    A "query" differs from a "fetch" in that it only retrieves values already stored in the persistent store. As such, values from unsaved transactions or contexts will not be incorporated in the query result.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter selectClause: a `Select<U>` clause indicating the properties to fetch, and with the generic type indicating the return type.
    - parameter queryClauses: a series of `QueryClause` instances for the query request. Accepts `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
    - returns: the result of the the query. The type of the return value is specified by the generic type of the `Select<U>` parameter.
    */
    public func queryAttributes<T: NSManagedObject>(from: From<T>, _ selectClause: Select<NSDictionary>, _ queryClauses: QueryClause...) -> [[NSString: AnyObject]]? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to query from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.queryAttributes(from, selectClause, queryClauses)
    }
    
    /**
    Queries a dictionary of attribute values as specified by the `QueryClause`s. Requires at least a `Select` clause, and optional `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
    
    A "query" differs from a "fetch" in that it only retrieves values already stored in the persistent store. As such, values from unsaved transactions or contexts will not be incorporated in the query result.
    
    - parameter from: a `From` clause indicating the entity type
    - parameter selectClause: a `Select<U>` clause indicating the properties to fetch, and with the generic type indicating the return type.
    - parameter queryClauses: a series of `QueryClause` instances for the query request. Accepts `Where`, `OrderBy`, `GroupBy`, and `Tweak` clauses.
    - returns: the result of the the query. The type of the return value is specified by the generic type of the `Select<U>` parameter.
    */
    public func queryAttributes<T: NSManagedObject>(from: From<T>, _ selectClause: Select<NSDictionary>, _ queryClauses: [QueryClause]) -> [[NSString: AnyObject]]? {
        
        CoreStore.assert(
            NSThread.isMainThread(),
            "Attempted to query from a \(typeName(self)) outside the main thread."
        )
        
        return self.mainContext.queryAttributes(from, selectClause, queryClauses)
    }
}
