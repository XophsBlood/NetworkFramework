//
//  PersistenceTests.swift
//  CoreLogicTests
//
//  Created by Камиль Бакаев on 09.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
import CoreLogic

class PersistenceTests: XCTestCase {
    
    let url = URL(string: "http://moc")!
    let antoherImagesResult = ImagesResult(hasMore: false, page: 1, pageCount: 1, pictures: [])

    
    func getLocalLoader() -> (Store, Data) {
        let store = Store()
        let data = try! JSONEncoder().encode(antoherImagesResult)
        store.clearData(with: url)
        return (store, data)
    }
    
    func test_cache_add() {
        let (store, expectedData) = getLocalLoader()
        
        store.save(data: expectedData, url: url)
        let data = store.getData(with: url)
        XCTAssertEqual(data, expectedData)
    }
    
    func test_cache_empty() {
        let (store, _) = getLocalLoader()
        XCTAssertNil(store.getData(with: url))
    }
    
    func test_cache_clear() {
        let (store, _) = getLocalLoader()
        
        store.clearData(with: url)
        XCTAssertNil(store.getData(with: url))
        store.clearData(with: url)
        XCTAssertNil(store.getData(with: url))
        
    }
    
    func test_cache_can_be_deleted() {
        let (store, expectedData) = getLocalLoader()
        store.save(data: expectedData, url: url)
        store.clearData(with: url)
        XCTAssertNil(store.getData(with: url))
        
    }


}
