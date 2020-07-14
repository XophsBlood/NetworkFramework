//
//  LocalImageDataLoaderTests.swift
//  CoreLogicTests
//
//  Created by Камиль Бакаев on 13.07.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
@testable import CoreLogic

class LocalImageDataLoaderTests: XCTestCase {
    let url = URL(string: "http://url.com/images?page=2")!

    func getStoreAndLocalLoader() -> (LocalImageDataLoader, MockStore) {
        let mockStore = MockStore()
        let localImageDataLoader = LocalImageDataLoader(store: mockStore)
        return (localImageDataLoader, mockStore)
    }
    
    func testGetImageDataCalls() {
        let (localImageDataLoader, mockStore) = getStoreAndLocalLoader()
        localImageDataLoader.getImageData(with: URL(string: "http://url")!)
        let expectedArray: [CalledMethod] = [.getData]
        XCTAssertEqual(expectedArray, mockStore.arrayStr)
    }
    
    func testCacheCalls() {
        let (localImageDataLoader, mockStore) = getStoreAndLocalLoader()
        localImageDataLoader.cache(with: url,  and: Data())
        let expectedArray: [CalledMethod] = [.getMainCacheData, .save]
        XCTAssertEqual(expectedArray, mockStore.arrayStr)
    }
    
    func testSaveMainCalls() {
        let (localImageDataLoader, mockStore) = getStoreAndLocalLoader()
        localImageDataLoader.saveMain(imagesResult: ImagesResult(hasMore: true, page: 1, pageCount: 1, pictures: []))
        let expectedArray: [CalledMethod] = [.clearCache, .saveMain]
        XCTAssertEqual(expectedArray, mockStore.arrayStr)
    }
    
    func testGetImagesCalls() {
        let (localImageDataLoader, mockStore) = getStoreAndLocalLoader()
        localImageDataLoader.getImages(with: url) {_ in }
        let expectedArray: [CalledMethod] = [.checkExpirationDate, .getMainCacheData]
        XCTAssertEqual(expectedArray, mockStore.arrayStr)
    }
    
    func testGetImageDataCalls_Protocol() {
        let (localImageDataLoader, mockStore) = getStoreAndLocalLoader()
        localImageDataLoader.getImageData(with: url) {_ in }
        let expectedArray: [CalledMethod] = [.getData]
        XCTAssertEqual(expectedArray, mockStore.arrayStr)
        
    }
}
