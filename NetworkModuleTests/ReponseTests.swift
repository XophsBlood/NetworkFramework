//
//  ReponseTests.swift
//  NetworkModuleTests
//
//  Created by Камиль Бакаев on 09.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
@testable import NetworkModule

class ReponseTests: XCTestCase {
    let expectation = XCTestExpectation(description: "Download https://jsonplaceholder.typicode.com/posts/1")
    
    var testHTTPClient: HTTPClient!
    var url: URL!

    override func setUp() {
        super.setUp()
        url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")
        testHTTPClient = NetworkManager()
    }

    override func tearDown() {
        super.tearDown()
        url = nil
        testHTTPClient = nil
    }

    func testGetDataAndHTTPURLResponse() throws {
        testHTTPClient.get(from: url) { [weak self] (result: Result) in
            switch result {
            case .success((_, _)): break
                
            case .failure(_):
                XCTFail()
            }
            self?.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
