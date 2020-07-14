//
//  Store.swift
//  CoreLogic
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation

public class Store: ImageStore {
    private let userDefault = UserDefaults.standard
    static let mainCacheKey = "MainCache"
    private let maxExpirationDate: TimeInterval = 10000
    public init() {}
    
    public func save(data: Data, url: URL) {
        userDefault.set(data, forKey: url.absoluteString)
        
    }
    
    public func saveMain(data: Data, page: String) {
        userDefault.set(data, forKey: page)
    }
    
    public func clearCache(page: String) {
        if let data = userDefault.data(forKey: page), let tempImagesDataEntity = try? JSONDecoder().decode(TempImagesDataEntity.self, from: data) {
            for i in tempImagesDataEntity.imagesData {
                clearData(with: i)
            }
            userDefault.removeObject(forKey: Store.mainCacheKey)
        }
    }
    
    public func chechExpirationDate(page: String) -> Bool {
        guard let data = userDefault.data(forKey: page)  else {
            return false
        }
        
        guard let tempImagesDataEntity = try? JSONDecoder().decode(TempImagesDataEntity.self, from: data) else {
            return false
        }
        let currentDate = Date.timeIntervalSinceReferenceDate
        let currentCacheDate = tempImagesDataEntity.cacheTime
        let currentExpirationDate = currentDate - currentCacheDate
        print(currentExpirationDate)
        print(maxExpirationDate)
        return currentExpirationDate < maxExpirationDate
    }
    
    public func getData(with url: URL) -> Data? {
        let data = userDefault.data(forKey: url.absoluteString)
        return data
    }
    
    public func getMainCacheData(page: String) -> Data? {
        return userDefault.data(forKey: page)
    }
    
    public func clearData(with url: URL) {
        userDefault.removeObject(forKey: url.absoluteString)
    }
}

public protocol ImageStore {
    func saveMain(data: Data, page: String)
    func clearCache(page: String)
    func save(data: Data, url: URL)
    func getData(with url: URL) -> Data?
    func chechExpirationDate(page: String) -> Bool
    func getMainCacheData(page: String) -> Data?
    func clearData(with url: URL)
}
