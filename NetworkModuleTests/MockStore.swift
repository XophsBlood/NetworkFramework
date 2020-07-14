//
//  MockStore.swift
//  CoreLogicTests
//
//  Created by Камиль Бакаев on 13.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import Foundation
import CoreLogic

class MockStore: ImageStore {
    var arrayStr: [CalledMethod] = []
    
    func saveMain(data: Data, page: String) {
        arrayStr.append(.saveMain)
    }
    
    func clearCache(page: String) {
        arrayStr.append(.clearCache)
    }
    
    func save(data: Data, url: URL) {
        arrayStr.append(.save)
    }
    
    func getData(with url: URL) -> Data? {
        arrayStr.append(.getData)
        return nil
    }
    
    func checkExpirationDate(page: String) -> Bool {
        arrayStr.append(.checkExpirationDate)
        return true
    }
    
    func getMainCacheData(page: String) -> Data? {
        arrayStr.append(.getMainCacheData)
        return nil
    }
    
    func clearData(with url: URL) {
        arrayStr.append(.clearData)
    }
    
    
}

enum CalledMethod: Equatable {
    case saveMain
    case clearCache
    case save
    case getData
    case checkExpirationDate
    case getMainCacheData
    case clearData
}
