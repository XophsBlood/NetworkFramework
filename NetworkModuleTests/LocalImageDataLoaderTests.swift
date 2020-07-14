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
        XCTAssertTrue(mockStore.arrayStr.contains("getData"))
    }
    
    func testCacheCalls() {
        let (localImageDataLoader, mockStore) = getStoreAndLocalLoader()
        localImageDataLoader.cache(with: url,  and: Data())
        XCTAssertTrue(mockStore.arrayStr.contains("getMainCacheData"))
        XCTAssertTrue(mockStore.arrayStr.contains("save"))
    }
    
    func testSaveMainCalls() {
        let (localImageDataLoader, mockStore) = getStoreAndLocalLoader()
        localImageDataLoader.saveMain(imagesResult: ImagesResult(hasMore: true, page: 1, pageCount: 1, pictures: []))
        XCTAssertTrue(mockStore.arrayStr.contains("clearCache"))
        XCTAssertTrue(mockStore.arrayStr.contains("saveMain"))
    }
    
    func testGetImagesCalls() {
        let (localImageDataLoader, mockStore) = getStoreAndLocalLoader()
        localImageDataLoader.getImages(with: url) {_ in }
        XCTAssertTrue(mockStore.arrayStr.contains("chechExpirationDate"))
        XCTAssertTrue(mockStore.arrayStr.contains("getMainCacheData"))
    }
    
    func testGetImageDataCalls_Protocol() {
        let (localImageDataLoader, mockStore) = getStoreAndLocalLoader()
        localImageDataLoader.getImageData(with: url) {_ in }
        XCTAssertTrue(mockStore.arrayStr.contains("getData"))
        
    }
}
