//
//  IntegratedUnitTests.swift
//  IntegratedUnitTests
//
//  Created by Камиль Бакаев on 26.06.2020.
//  Copyright © 2020 Камиль Бакаев. All rights reserved.
//

import XCTest
@testable import NetworkModule

class IntegratedUnitTests: XCTestCase {
    let expectation = XCTestExpectation(description: "Download https://failUrl")

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_auth() {
        let myURLSession = URLSession(configuration: .default)
        let httpClient = NetworkManager(session: myURLSession)
        let auth = AuthHTTPClient(httpClient: httpClient)
        let tokenloader = HTTPTokenLoader(httpCLient: auth)
        let myurl = URL(string: "http://195.39.233.28:8035/auth")
        let dictionary = ["apiKey": "23567b218376f79d9415"]

        tokenloader.auth(with: myurl!, params: dictionary) { result in
            switch result {
            case let .success(auth):
                print(AuthHTTPClient.token)
                print(auth.token)
            case let .failure(error):
                print(error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)

        
        
    }
    
    func test_images() {
        let myURLSession = URLSession(configuration: .default)
        let httpClient = NetworkManager(session: myURLSession)
        let auth = AuthHTTPClient(httpClient: httpClient)
        let tokenloader = HTTPImagesLoader(httpCLient: auth)
        let myurl = URL(string: "http://195.39.233.28:8035/images")

        tokenloader.getImages(with: myurl!) { result in
            switch result {
            case let .success(images):
                print(images.pictures)
            case let .failure(error):
                print(error)
            }
            self.expectation.fulfill()

        }

        wait(for: [expectation], timeout: 10.0)



    }

    func test_image() {
        let myURLSession = URLSession(configuration: .default)
        let httpClient = NetworkManager(session: myURLSession)
        let auth = AuthHTTPClient(httpClient: httpClient)
        let tokenloader = HTTPImageDetailsLoader(httpCLient: auth)
        let myurl = URL(string: "http://195.39.233.28:8035/images/51fbadf55aa5d2966e98")

        tokenloader.getImageDetails(with: myurl!) { result in
            switch result {
            case let .success(imageDetails):
                print(imageDetails)
            case let .failure(error):
                print(error)
            }
            self.expectation.fulfill()

        }

        wait(for: [expectation], timeout: 10.0)



    }

}
