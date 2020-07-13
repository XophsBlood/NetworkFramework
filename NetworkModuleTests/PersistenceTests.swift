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

    func getDataLoaders<T: Encodable>(structure: T) -> (LocalImageDataLoader, HTTPImagesLoader) {
        let session = MockURLSession()
        let data = try! JSONEncoder().encode(structure)
        let networkManager = MockHTTPClient(session: session, data: data)
        memoryLeakTrack(networkManager)
        let store = Store()
        let localImageDataLoader = LocalImageDataLoader(store: store)
        let imagesLoader = HTTPImagesLoader(httpCLient: networkManager, localImageDataLoader: localImageDataLoader)
        
        return (localImageDataLoader, imagesLoader)
    }
    
    func test_cache_clear_and_add() {
        let imagesResult = ImagesResult(hasMore: true, page: 1, pageCount: 1, pictures: [])
        let (localImageDataLoader, imagesLoader) = getDataLoaders(structure: imagesResult)
        let expectedData = try! JSONEncoder().encode(imagesResult)
        localImageDataLoader.store.clearCache(page: "1")
        imagesLoader.getImages(with: url) { result in
            switch result {
            case let .success(data):
                print(data)
                let newData = try! JSONDecoder().decode(TempImagesDataEntity.self, from: localImageDataLoader.store.getMainCacheData(page: "1")!)
                let encoded = try! JSONEncoder().encode(newData.imagesResult)
                print(newData)
                XCTAssertEqual(expectedData, encoded)
                localImageDataLoader.store.clearCache(page: "1")
            case let .failure(error):
                XCTFail()
            }
        }
       
        
        let antoherImagesResult = ImagesResult(hasMore: false, page: 1, pageCount: 1, pictures: [])
        let (anotherLocalImageDataLoader, anotherImagesLoader) = getDataLoaders(structure: antoherImagesResult)
        let anotherExpectedData = try! JSONEncoder().encode(antoherImagesResult)
        
        anotherImagesLoader.getImages(with: url) { result in
            switch result {
            case let .success(data):
                let newData = try! JSONDecoder().decode(TempImagesDataEntity.self, from: localImageDataLoader.store.getMainCacheData(page: "1")!)
                let encoded = try! JSONEncoder().encode(newData.imagesResult)
                XCTAssertEqual(anotherExpectedData, encoded)
            case let .failure(error):
                XCTFail()
            }
        }
    }

}
